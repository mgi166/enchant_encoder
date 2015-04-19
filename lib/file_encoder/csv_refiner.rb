require 'csv'

module FileEncoder
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

      def foreach(path, options = Hash.new, &block)
        return to_enum(__method__, path, options) unless block
        open(path, options) do |csv|
          csv.each(&block)
        end
      end
    end
  end

  class CsvRefiner
    def initialize(obj)
      @obj = obj
    end

    using CSVExtention

    def foreach(*args, &block)
      CSV.foreach(*args, &block)
    end

    def open(*args, &block)
      CSV.open(*args, &block)
    end
  end
end
