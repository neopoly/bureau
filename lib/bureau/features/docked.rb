module Bureau
  module Features
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
