module Settei
  module Hook
    class << self
      def append_features(rcvr); hook(rcvr); end
      def prepend_features(rcvr); hook(rcvr); end

      def hook(rcvr)
        @features&.each do |feat, block|
          rcvr.define_singleton_method(feat, &block)
        end

        @ini_features&.each do |feat, block|
          rcvr.define_singleton_method(feat, &block.call(rcvr))
        end
      end

      def register(*features)
        @features ||= []
        features.each { |feat| @features += feat}
      end

      def register_with_reciever(*features)
        @ini_features ||= []
        features.each { |feat| @ini_features += feat}
      end
    end
  end
end
