module Bureau
  module Features
    class Collection
      attr_reader :renderer

      def initialize(renderer)
        @renderer = renderer
      end

      def add(feature)
        collection << feature
      end

      def apply!
        collection.each do |c|
          case c
          when :filter then Filter.new(renderer).call 
          when :docked then Docked.new(renderer).call
          end
          applied << c
        end
      end

      def applied
        @applied ||= []
      end

      private

      def collection
        @collection ||= []
      end
    end
  end
end
