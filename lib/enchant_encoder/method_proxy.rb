require 'file_encoder/proxy/nkf_each.rb'

module FileEncoder
  class MethodProxy
    def initialize(obj)
      @obj = obj
    end

    def each(*args, &block)
      if @obj.respond_to?(:each)
        @obj.each do |row|
          yield ::NKF.nkf('-Lu -w -m0', row)
        end
      else
        @obj.each(*args, &block)
      end
    end

    def foreach(*args, &block)
      if @obj.respond_to?(:foreach)
        @obj.foreach(*args) do |row|
          yield ::NKF.nkf('-Lu -w -m0', row)
        end
      else
        @obj.foreach(*args, &block)
      end
    end

    def open(*args, &block)
      if @obj.respond_to?(:open)
        new = @obj.open(*args, &block)
        new.extend(FileEncoder::Proxy::NkfEach)
      else
        @obj.open(*args, &block)
      end
    end
  end
end
