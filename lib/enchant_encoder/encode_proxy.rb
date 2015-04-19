require 'file_encoder/nkf_each.rb'
require 'csv'
require 'nkf'

module CSVExtention
  refine CSV.singleton_class do
    def open(*args)
      # find the +options+ Hash
      options = if args.last.is_a? Hash then args.pop else Hash.new end
      # wrap a File opened with the remaining +args+ with no newline
      # decorator
      file_opts = {universal_newline: false}.merge(options)
      begin
        # NOTE: This IO object that I want to extend module
        f = File.open(*args, file_opts).extend(FileEncoder::NkfGets)
      rescue ArgumentError => e
        raise unless /needs binmode/ =~ e.message and args.size == 1
        args << "rb"
        file_opts = {encoding: Encoding.default_external}.merge(file_opts)
        retry
      end
      begin
        csv = new(f, options)
      rescue Exception
        f.close
        raise
      end

      # handle blocks like Ruby's open(), not like the CSV library
      if block_given?
        begin
          yield csv
        ensure
          csv.close
        end
      else
        csv
      end
    end
  end
end

module FileEncoder
  class EncodeProxy
    using CSVExtention

    def initialize(obj)
      @obj = obj
    end

    def each(*args, &block)
      if @obj.respond_to?(:each)
        if block_given?
          @obj.each do |row|
            yield ::NKF.nkf('-Lu -w -m0', row)
          end
        else
          @obj.each.extend(NkfEach)
        end
      else
        @obj.each(*args, &block)
      end
    end

    def foreach(*args, &block)
      if @obj.respond_to?(:foreach)
        if block_given?
          @obj.foreach(*args) do |row|
            yield ::NKF.nkf('-Lu -w -m0', row)
          end
        else
          @obj.foreach(*args).extend(NkfEach)
        end
      else
        @obj.foreach(*args, &block)
      end
    end

    def open(*args, &block)
      if @obj == CSV
        CSV.open(*args, &block)
      else
        if @obj.respond_to?(:open)
          io = @obj.open(*args).extend(NkfEach)
          block_given? ? yield(io) : io
        else
          @obj.open(*args, &block)
        end
      end
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end
  end
end
