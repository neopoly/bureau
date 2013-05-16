module Bureau
  module Features
    class Docked
      def self.call(renderer)
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
