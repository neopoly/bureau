require "test_helper"

module Bureau
  module Cell
    class BaseTest < ActiveSupport::TestCase

      it "return given value" do
        cell_presenter = Class.new do
          include Bureau::Cell::Base
        end.new("foo")

        assert_equal "foo", cell_presenter.value
      end

      describe "type" do
        it "return String if value is kind of string" do
          cell_presenter = Class.new do
            include Bureau::Cell::Base
          end.new("foo")

          assert_equal "String", cell_presenter.type
        end

        it "return Number if value is kind of integer" do
          cell_presenter = Class.new do
            include Bureau::Cell::Base
          end.new(1)

          assert_equal "Number", cell_presenter.type
        end
      end

    end
  end
end
