module Bureau
  module Features
    class Base

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
          when :filter then renderer.worksheet.auto_filter = renderer.worksheet.dimension.sqref
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
