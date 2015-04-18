module FileEncoder
  module Extendable
    EXTEND_METHOS = %w(each foreach open)

    def extend_methods!(obj)
      EXTEND_METHOS.each do |method|
        if obj.respond_to?(method)
          const_name = "Nkf#{method.capitalize}"

          begin
            module_name = FileEncoder::Proxy.const_get(const_name)
            obj.extend(module_name)
          rescue NameError
          end
        end
      end

      obj
    end
  end
end
