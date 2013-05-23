module Bureau
  module Cell
    module Base

      module InstanceMethods
        attr_reader :value, :type

        def initialize(value, type = nil)
          @value = value
          @type  = type
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
