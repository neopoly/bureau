require "test_helper"

module Bureau
  module Row
    class BaseTest < TestCase

      it "return given object" do
        object = Object.new

        row_presenter = Class.new do
          include Bureau::Row::Base
        end.new(object)

        assert_equal object, row_presenter.object
      end

      it "call methods on row presenter" do
        object = Class.new do
          def name
            :foo
          end
        end.new

        row_presenter = Class.new do
          include Bureau::Row::Base
          def name
            :bar
          end
        end.new(object)

        assert_equal :bar, row_presenter.name
      end

      it "delegates methods to object if they are not defined in row presenter" do
        object = Class.new do
          def name
            :foo
          end
        end.new

        row_presenter = Class.new do
          include Bureau::Row::Base
        end.new(object)

        assert_equal :foo, row_presenter.name
      end

    end
  end
end
