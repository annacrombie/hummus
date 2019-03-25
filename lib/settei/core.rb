module Settei
  class << self
    def setup(pub:, priv: {}, accessors: DEFAULTS[:accessors],
              prefix: DEFAULTS[:prefix], var: DEFAULTS[:var])
      Settei::Hook.dup.yield_self do |mod|
        acc = Settei.make_accessor(pub, priv, var)
        mod.register(methods_for(pub, mod, prefix, var))
        mod.register_with_reciever(accessors.map { |n| [n, acc] })
        mod
      end
    end

    def make_accessor(pub, priv, var)
      conf = pub.dup.merge!(priv)

      lambda do |rcvr|
        rcvr.instance_variable_set(var, conf)
        ->(&b) { b.nil? ? instance_variable_get(var) : b.call(rcvr) }
      end
    end

    # define convinence methods for each of the configuration paramaters special
    # methods added for parameters that take booleans, e.g. dont_xxxx or xxxx!
    def methods_for(config, rcvr, prefix, var)
      config.reduce([]) do |m, (k, v)|
        (case v
         when true, false
           [[:"dont_#{k}", -> { instance_variable_get(var)[k] = false }],
            [:"do_#{k}",   -> { instance_variable_get(var)[k] = true }],
            [:"#{k}!",     -> { instance_variable_get(var)[k] = true }],
            [:"#{k}?",     -> { instance_variable_get(var)[k] }],
            [:"#{k}=",     lambda { |l|
              unless [TrueClass, FalseClass].include?(l.class)
                raise TypeError, "expected #{l.inspect} to be a kind_of? Bool (true, or false)"
              end

              instance_variable_get(var)[k] = l
            }]]
         else
           [[:"#{k}=",     lambda { |l|
                             unless l.is_a?(v.class)
                               raise TypeError, "expected #{l.inspect} to be a kind_of? #{v.class}"
                             end

                             instance_variable_get(var)[k] = l
                           }]]
        end +
          [[:"#{k}", -> { instance_variable_get(var)[k] }]]
        ).map { |k, v| [:"#{prefix}#{k}", v] } + m
      end
    end
  end
end
