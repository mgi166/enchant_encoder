require 'nkf'

module FileEncoder
  class EncodeProxy
    EXTEND_METHOS = %w(each foreach)

    def initialize(obj)
      @obj = obj.dup

      if EXTEND_METHOS.any? { |method| @obj.respond_to?(method) }
        @obj.extend(FileEncoder::Nkfable)
      else
        @obj
      end
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end
  end
end
