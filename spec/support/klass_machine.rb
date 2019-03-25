module KlassMachine
  def newklass(hash)
    klass = Class.new
    klass.prepend(Settei.setup(hash))
    klass
  end
end
