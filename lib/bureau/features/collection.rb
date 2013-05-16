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

    class Filter
      attr_reader :renderer

      def initialize(renderer)
        @renderer = renderer
      end

      def call
        renderer.worksheet.auto_filter = renderer.worksheet.dimension.sqref
      end
    end

    class Docked
      attr_reader :renderer

      def initialize(renderer)
        @renderer = renderer
      end

      def call
        renderer.worksheet.sheet_view.pane do |pane|
          pane.top_left_cell = "B2"
          pane.state = :frozen_split
          pane.y_split = 1 # rows docked on top
          pane.x_split = 0 # rows docked left
        end
      end
    end
  end
end
