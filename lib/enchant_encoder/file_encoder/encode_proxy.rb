require 'nkf'

module FileEncoder
  class EncodeProxy
    EXTEND_METHOS = %w(each foreach)

    def initialize(obj)
      @obj = obj.dup
      extend_methods!
    end

    def method_missing(method, *args, &block)
      @obj.send(method, *args, &block)
    end

    def extend_methods!
      EXTEND_METHOS.each do |method|
        if @obj.respond_to?(method)
          const_name = "Nkf#{method.capitalize}"

          begin
            module_name = FileEncoder::Proxy.const_get(const_name)
            @obj.extend(module_name)
          rescue NameError
          end
        end
      end

      @obj
    end
  end
end
