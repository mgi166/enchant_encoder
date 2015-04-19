require 'csv'
require 'nkf'

module FileEncoder
  class EncodeProxy
    def initialize(obj, options)
      @obj = obj
      @options = options
    end

    def each(*args, &block)
      if block_given?
        @obj.each do |row|
          yield ::NKF.nkf('-Lu -w -m0', row)
        end
      else
        @obj.each.extend(NkfMethods::Each)
      end
    end

    def foreach(*args, &block)
      if @obj == CSV
        CsvRefiner.new(@obj).foreach(*args, &block)
      else
        if block_given?
          @obj.foreach(*args) do |row|
            yield ::NKF.nkf('-Lu -w -m0', row)
          end
        else
          @obj.foreach(*args).extend(NkfMethods::Each)
        end
      end
    end

    def open(*args, &block)
      if @obj == CSV
        CsvRefiner.new(@obj).open(*args, &block)
      else
        io = @obj.open(*args).extend(NkfMethods::Each)
        block_given? ? yield(io) : io
      end
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end
  end
end
