module EnchantEncoder
  class Config
    attr_accessor :nkf_option

    def initialize
      @nkf_option = '-Lu -w -m0'
    end
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
