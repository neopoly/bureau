module Bureau
  module Features
    class Collection
      attr_reader :renderer, :applied, :collection
      private :collection

      def initialize(renderer)
        @renderer   = renderer
        @applied    = []
        @collection = []
      end

      def add(feature)
        collection << feature
      end

      def apply!
        collection.each do |feature|
          feature.call(renderer)
          applied << feature
        end
      end
    end
  end
end
