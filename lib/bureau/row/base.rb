module Bureau
  module Row
    module Base

      module InstanceMethods
        attr_accessor :object

        def initialize(object)
          @object = object
        end

        def method_missing(method, *args)
          return object.send(method, *args) if object.respond_to?(method)
          super
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
