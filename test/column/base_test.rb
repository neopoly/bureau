require "test_helper"

module Bureau
  module Column
    class BaseTest < TestCase

      it "returns key" do
        assert_equal 'foo', klass.new('foo','FOO',:string).key
        assert_equal 'bar', klass.new('bar','BAR').key
        assert_equal 'baz', klass.new('baz').key
      end

      it "returns label" do
        assert_equal 'FOO', klass.new('foo','FOO',:string).label
        assert_equal 'BAR', klass.new('bar','BAR').label
        assert_equal 'Baz', klass.new('baz').label
      end

      it "returns type" do
        assert_equal :string, klass.new('foo','FOO',:string).type
        assert_equal nil, klass.new('bar','BAR').type
        assert_equal nil, klass.new('baz').type
      end

      private

      def klass
        Bureau::Column::Base
      end

    end
  end
end
