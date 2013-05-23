module Bureau
  module Column
    class Base

      attr_reader :key, :label, :type

      def initialize(key, label = nil, type = nil)
        @key   = key
        @label = label || key.capitalize
        @type  = type
      end

      def ==(other)
        key == other.key && label == other.label && type == other.type
      end

    end
  end
end
