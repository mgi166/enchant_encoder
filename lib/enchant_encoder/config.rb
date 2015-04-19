module EnchantEncoder
  class Config
    attr_accessor :nkf_option
  end

  class << self
    def configure(&block)
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end
