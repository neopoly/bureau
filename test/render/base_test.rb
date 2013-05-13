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

    end
  end
end
