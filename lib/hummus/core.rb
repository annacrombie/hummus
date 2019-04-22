module Hummus
  class << self
    def setup(hash)
      Hummus::Hook.dup.tap { |h| h.stash = Chickpea.new(hash) }
    end
  end
end
