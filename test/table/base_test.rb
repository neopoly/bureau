require "test_helper"

module Bureau
  module Table
    class BaseTest < TestCase

      describe "default_name" do
        it "return default sheet name" do
          assert_nil subject.new.name
        end

        it "accept optional name" do
          assert_equal 'MySheet', subject.new(:name => 'MySheet').name
        end
      end

      describe "default_features" do
        it "return default features" do
          assert_nil subject.new.features
        end

        it "accept optional features" do
          assert_equal [:filter], subject.new(:features => [:filter]).features
        end
      end

      describe "columns" do
        it "raises if default_columns are not defined" do
          assert_raises Bureau::Errors::MissingDefaultColumnsError do
            subject_without_default_columns.new
          end
        end

        it "return default columns" do
          expected = {
              'foo' => 'FOO',
              'bar' => 'BAR'
            }

          assert_equal expected, subject.new.columns
        end

        it "return specific columns" do
          expected = { 'foo' => 'FOO' }

          assert_equal expected, subject.new(:columns => ['foo']).columns
        end

        it "return specific columns and rename them" do
          expected = { 'foo' => 'F00' }

          assert_equal expected, subject.new(:columns => {'foo' => 'F00'}).columns
        end
      end

      describe "header" do
        it "return default columns" do
          instance = subject.new

          assert_equal 2, instance.header.count

          assert_equal 'FOO', instance.header[0].value
          assert_equal 'String', instance.header[0].type

          assert_equal 'BAR', instance.header[1].value
          assert_equal 'String', instance.header[1].type
        end

        it "return specific columns" do
          instance = subject.new(:columns => ['foo'])

          assert_equal 1, instance.header.count
          assert_equal 'FOO', instance.header[0].value
          assert_equal 'String', instance.header[0].type
        end

        it "return specific columns and rename them" do
          expected = { 'foo' => 'F00' }
          instance = subject.new(:columns => {'foo' => 'F00'})

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
          renderer = Bureau::Render::Base

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

          def default_columns
            {
              'foo' => 'FOO',
              'bar' => 'BAR'
            }
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
          def default_columns
          end
        end
      end

      def subject_without_default_columns
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

          def default_columns
          end
        end
      end

    end
  end
end
