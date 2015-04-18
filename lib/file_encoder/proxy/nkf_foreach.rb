module FileEncoder::Proxy
  module NkfForeach
    def foreach(*args, &block)
      super(*args) do |row|
        yield ::NKF.nkf('-Lu -w -m0', row)
      end
    end
  end
end
