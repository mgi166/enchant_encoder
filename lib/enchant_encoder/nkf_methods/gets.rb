module EnchantEncoder::NkfMethods
  module Gets
    def gets(*args)
      if str = super(*args)
        ::NKF.nkf('-Lu -w -m0', str)
      end
    end
  end
end
