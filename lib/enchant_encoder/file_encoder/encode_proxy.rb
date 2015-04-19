require 'nkf'

module FileEncoder
  class EncodeProxy
    def initialize(obj)
      @obj = obj.dup
      @obj.extend(FileEncoder::Proxy::Nkfable)
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end
  end
end
