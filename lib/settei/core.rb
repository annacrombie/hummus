module Settei
  class << self
    def setup(hash)
      Settei::Hook.dup.tap { |h| h.stash = CStash::Stash.new(hash) }
    end
  end
end
