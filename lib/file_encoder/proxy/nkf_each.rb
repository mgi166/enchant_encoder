module FileEncoder::Proxy
  module NkfEach
    def each(*args, &block)
      super(*args) do |row|
        yield ::NKF.nkf('-Lu -w -m0', row)
      end
    end
  end
end
