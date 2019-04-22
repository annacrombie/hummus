module Hummus
  module Hook
    class << self
      attr_accessor :stash

      def hook(rcvr)
        stash = @stash

        rcvr.define_singleton_method(:config) do |&block|
          return stash if block.nil?

          block.call(stash)
        end

        rcvr.const_set(:HummusHook, self)
      end

      alias append_features hook
      alias prepend_features hook
    end
  end
end
