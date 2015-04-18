module FileEncoder::Proxy
  module Nkfable
    def foreach(*args, &block)
      super(*args) do |row|
        yield ::NKF.nkf('-Lu -w -m0', row)
      end
    end
  end
end