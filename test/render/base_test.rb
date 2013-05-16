require "test_helper"

module Bureau
  module Render
    class BaseTest < TestCase

      it "return header" do
        renderer = Class.new do
          include Bureau::Render::Base
        end.new(:header => [1,2])

        assert_equal [1,2], renderer.header
      end

      it "return rows" do
        renderer = Class.new do
          include Bureau::Render::Base
        end.new(:rows => [1,2])

        assert_equal [1,2], renderer.rows
      end

      it "provide render method" do
        renderer = Class.new do
          include Bureau::Render::Base
        end.new

        assert renderer.respond_to? :render
      end

      it "return a package" do
        assert_kind_of Axlsx::Package, renderer.package
      end

      it "return a workbook" do
        assert_kind_of Axlsx::Workbook, renderer.workbook
      end

      it "return a worksheet" do
        assert_kind_of Axlsx::Worksheet, renderer.worksheet
      end

      it "render - apply features" do
        assert_equal [], renderer.features.applied
        renderer.render
        assert_equal [:filter], renderer.features.applied
      end

      it "feature filter" do
        assert_nil renderer.worksheet.auto_filter.range

        renderer.features.add(:filter)
        renderer.features.apply!

        assert_equal "A1:B2", renderer.worksheet.auto_filter.range
      end

      # TODO: Integrationtest - Open xlsx again
      it "render - return xlsx" do
        assert renderer.render
      end

      private

      def renderer
        if @instance
          @instance
        else
          header = [cell("foo"), cell(1)]
          rows   = [header]

          @instance = Class.new do
            include Bureau::Render::Base
          end.new(:header => header, :rows => rows)
        end
      end

      def cell(item)
        Class.new do
          include Bureau::Cell::Base
        end.new(item)
      end

    end
  end
end
