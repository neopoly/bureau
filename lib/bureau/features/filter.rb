module Bureau
  module Features
    class Filter
      attr_reader :renderer

      def initialize(renderer)
        @renderer = renderer
      end

      def call
        renderer.worksheet.auto_filter = renderer.worksheet.dimension.sqref
      end
    end
  end
end
