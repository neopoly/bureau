module Bureau
  module Cell
    module Base

      module InstanceMethods
        attr_reader :value

        def initialize(value)
          @value = value
        end

        def type
          value.kind_of?(Integer)? "Number" : "String"
        end
      end

      module ClassMethods
      end

      def included(mod)
        mod.extend ClassMethods
      end

      include InstanceMethods

    end
  end
end
