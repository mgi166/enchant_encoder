require 'nkf'
require 'file_encoder/extendable'

module FileEncoder
  class EncodeProxy
    include FileEncoder::Extendable

    def initialize(obj)
      @obj = obj
    end

    def method_missing(method, *args, &block)
      MethodProxy.new(@obj).send(method, *args, &block)
    end
  end
end
