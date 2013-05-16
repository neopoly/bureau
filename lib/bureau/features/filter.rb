module Bureau
  module Features
    class Filter
      def self.call(renderer)
        renderer.worksheet.auto_filter = renderer.worksheet.dimension.sqref
      end
    end
  end
end
