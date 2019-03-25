require 'settei/hook'
require 'settei/version'

module Settei
  CFG = :@settei_config

  class << self
    def make_accessor(pub, priv)
      conf = pub.dup.merge!(priv)

      lambda do |rcvr|
        rcvr.instance_variable_set(CFG, conf)
        ->(&b) { b.nil? ? instance_variable_get(CFG) : b.call(rcvr) }
      end
    end

    def setup(pub:, priv:, accessors: %i[config configure], prefix: :'')
      Settei::Hook.dup.yield_self do |mod|
        acc = Settei.make_accessor(pub, priv)
        mod.register(methods_for(pub, mod, prefix))
        mod.register_with_reciever(accessors.map { |n| [n, acc] })
        mod
      end
    end

    # define convinence methods for each of the configuration paramaters special
    # methods added for parameters that take booleans, e.g. dont_xxxx or xxxx!
    def methods_for(config, rcvr, prefix)
      config.reduce([]) do |m, (k, v)|
        (case v
         when true, false
           [[:"dont_#{k}", -> { instance_variable_get(CFG)[k] = false }],
            [:"do_#{k}",   -> { instance_variable_get(CFG)[k] = true }],
            [:"#{k}!",     -> { instance_variable_get(CFG)[k] = true }],
            [:"#{k}?",     -> { instance_variable_get(CFG)[k] }],
            [:"#{k}=",     lambda { |l|
              unless [TrueClass, FalseClass].include?(l.class)
                raise TypeError, "expected #{l.inspect} to be a kind_of? Bool (true, or false)"
              end

              instance_variable_get(CFG)[k] = l
            }]]
         else
           [[:"#{k}=",     lambda { |l|
                             unless l.is_a?(v.class)
                               raise TypeError, "expected #{l.inspect} to be a kind_of? #{v.class}"
                             end

                             instance_variable_get(CFG)[k] = l
                           }]]
        end +
          [[:"#{k}", -> { instance_variable_get(CFG)[k] }]]
        ).map { |k, v| [:"#{prefix}#{k}", v] } + m
      end
    end
  end
end
