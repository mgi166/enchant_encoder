module EnchantEncoder
  module Enchantable
    def encoded(options = {})
      EncodeProxy.new(self, options)
    end
  end
end
