require 'file_encoder/nkf_each.rb'
require 'nkf'

module FileEncoder
  class EncodeProxy
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
      if @obj.respond_to?(:open)
        io = @obj.open(*args).extend(NkfEach)
        block_given? ? yield(io) : io
      else
        @obj.open(*args, &block)
      end
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end
  end
end
