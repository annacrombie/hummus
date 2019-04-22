module Hummus
  class << self
    def setup(hash)
      Hummus::Hook.dup.tap { |h| h.stash = CStash::Stash.new(hash) }
    end
  end
end
