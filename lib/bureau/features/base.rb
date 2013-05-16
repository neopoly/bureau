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
          when :docked then
            renderer.worksheet.sheet_view.pane do |pane|
              pane.top_left_cell = "B2"
              pane.state = :frozen_split
              pane.y_split = 1 # rows docked on top
              pane.x_split = 0 # rows docked left
            end
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
