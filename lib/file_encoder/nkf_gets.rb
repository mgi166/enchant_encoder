module FileEncoder
  module NkfGets
    def gets(*args)
      ::NKF.nkf('-Lu -w -m0', super(*args))
    end
  end
end
