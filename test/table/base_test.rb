require "test_helper"

module Bureau
  module Table
    class BaseTest < TestCase

      describe "name" do
        it "return default sheet name" do
          assert_nil subject.new.name
        end

        it "accept optional name" do
          assert_equal 'MySheet', subject.new(:name => 'MySheet').name
        end
      end

      describe "attributes" do
        it "raises if default_attributes are not defined" do
          assert_raises Bureau::Errors::MissingDefaultAttributesError do
            subject_without_default_attributes.new
          end
        end

        it "return default attributes" do
          expected = {
              'foo' => 'FOO',
              'bar' => 'BAR'
            }

          assert_equal expected, subject.new.attributes
        end

        it "return specific attributes" do
          expected = { 'foo' => 'FOO' }

          assert_equal expected, subject.new(:attributes => ['foo']).attributes
        end

        it "return specific attributes and rename them" do
          expected = { 'foo' => 'F00' }

          assert_equal expected, subject.new(:attributes => {'foo' => 'F00'}).attributes
        end
      end

      describe "header" do
        it "return default attributes" do
          instance = subject.new

          assert_equal 2, instance.header.count

          assert_equal 'FOO', instance.header[0].value
          assert_equal 'String', instance.header[0].type

          assert_equal 'BAR', instance.header[1].value
          assert_equal 'String', instance.header[1].type
        end

        it "return specific attributes" do
          instance = subject.new(:attributes => ['foo'])

          assert_equal 1, instance.header.count
          assert_equal 'FOO', instance.header[0].value
          assert_equal 'String', instance.header[0].type
        end

        it "return specific attributes and rename them" do
          expected = { 'foo' => 'F00' }
          instance = subject.new(:attributes => {'foo' => 'F00'})

          assert_equal 1, instance.header.count
          assert_equal 'F00', instance.header[0].value
          assert_equal 'String', instance.header[0].type
        end
      end

      describe "rows" do
        it "return rows" do
          row = subject.new(:row_presenter => row_presenter).rows[0]
  
          cell = row[0]
          assert_equal 'foo', cell.value
          assert_equal 'String', cell.type
  
          cell = row[1]
          assert_equal 1, cell.value
          assert_equal 'Number', cell.type
        end
      end

      describe "collection" do
        it "raises if default_collection is not defined" do
          assert_raises Bureau::Errors::MissingDefaultCollectionError do
            subject_without_default_collection.new
          end
        end

        it "raises if collection is empty" do
          assert_raises Bureau::Errors::EmptyCollectionError do
            subject_with_empty_default_collection.new
          end

          assert_raises Bureau::Errors::EmptyCollectionError do
            subject.new(:collection => [])
          end
        end

        it "initialize with default collection" do
          assert_equal 2, subject.new.collection.size
        end

        it "initialize with optional collection" do
          assert_equal 1, subject.new(:collection => [Object.new]).collection.size
        end
      end

      describe "row presenter" do
        it "initialize with default row presenter" do
          refute_nil subject.new.row_presenter
        end

        it "initialize with optional row presenter" do
          row_presenter = Class.new do
            include Bureau::Row::Base
          end

          assert_equal row_presenter, subject.new(:row_presenter => row_presenter).row_presenter
        end
      end

      describe "cell presenter" do
        it "initialize with default cell presenter" do
          refute_nil subject.new.cell_presenter
        end

        it "initialize with optional cell presenter" do
          cell_presenter = Class.new do
            include Bureau::Cell::Base
          end

          assert_equal cell_presenter, subject.new(:cell_presenter => cell_presenter).cell_presenter
        end
      end

      describe "renderer" do
        it "initialize with default renderer" do
          refute_nil subject.new.renderer
        end

        it "initialize with optional renderer" do
          renderer = Class.new do
            include Bureau::Render::Base
          end

          instance = subject.new(:renderer => renderer)

          assert_equal renderer, instance.renderer
        end
      end

      private

      def subject
        Class.new do
          include Bureau::Table::Base
          def default_collection
            [Object.new, Object.new]
          end

          # HOTFIX: To ensure correct attribute order in Ruby 1.8.7
          # https://github.com/neopoly/bureau/issues/2
          def default_attributes
            ActiveSupport::OrderedHash.new().merge(
              {
                'foo' => 'FOO',
                'bar' => 'BAR'
              }
            )
          end
        end
      end

      def row_presenter
        Class.new do
          include Bureau::Row::Base

          def foo
            'foo'
          end

          def bar
            1
          end
        end
      end

      def subject_without_default_collection
        Class.new do
          include Bureau::Table::Base
          def default_attributes
          end
        end
      end

      def subject_without_default_attributes
        Class.new do
          include Bureau::Table::Base
          def default_collection
          end
        end
      end

      def subject_with_empty_default_collection
        Class.new do
          include Bureau::Table::Base
          def default_collection
            []
          end

          def default_attributes
          end
        end
      end

    end
  end
end
