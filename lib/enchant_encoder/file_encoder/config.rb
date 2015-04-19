module FileEncoder
  class Config
    attr_accessor :chunk_size, :nkf_option
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
