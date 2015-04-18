require 'nkf'

module FileEncoder
  class EncodeProxy
    def initialize(obj)
      @obj = obj
    end

    def method_missing(method, *args, &block)
      MethodProxy.new(@obj).send(method, *args, &block)
    end
  end
end
