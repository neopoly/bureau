require "test_helper"

module Bureau
  module Cell
    class BaseTest < TestCase

      it "return given value" do
        cell_presenter = Class.new do
          include Bureau::Cell::Base
        end.new("foo")

        assert_equal "foo", cell_presenter.value
      end

      describe "type" do
        it "return given type" do
          cell_presenter = Class.new do
            include Bureau::Cell::Base
          end.new("foo", :string)

          assert_equal :string, cell_presenter.type
        end

        it "return nil" do
          cell_presenter = Class.new do
            include Bureau::Cell::Base
          end.new("foo")

          assert_nil cell_presenter.type
        end
      end

    end
  end
end
