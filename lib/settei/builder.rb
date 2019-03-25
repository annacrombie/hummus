module Settei
  class << self
    def cfg(cfg = nil, &block)
      b = Builder.dup
      b.cfg = cfg unless cfg.nil?
      block.call(b) unless block.nil?
      b.build
    end
  end

  class Builder
    include Settei.setup(pub: DEFAULTS)

    class<<self
      def build
        Settei.setup(
          pub: cfg.reject { |k, _| private.include?(k) },
          priv: cfg.select { |k, _| private.include?(k) },
          accessors: accessors,
          prefix: prefix,
          var: var
        )
      end
    end
  end
end
