require 'nkf'

module FileEncoder
  class EncodeProxy
    def initialize(obj)
      @obj = obj.dup

      if @obj.respond_to?(:each)
        @obj.send(:extend, FileEncoder::Proxy::Nkfable)
      else
        @obj
      end
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end
  end
end
