module SourceHelper
  def src_path(name)
    Pathname.new(__dir__).join('../fixtures').join(name)
  end
end
