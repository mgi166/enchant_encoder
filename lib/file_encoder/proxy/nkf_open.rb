module FileEncoder::Proxy
  module NkfOpen
    include FileEncoder::Extendable

    def open(*args, &block)
      extend_methods!(super(*args))
    end
  end
end
