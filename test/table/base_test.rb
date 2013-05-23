require "test_helper"

module Bureau
  module Table
    class BaseTest < TestCase

      describe "default_name" do
        it "returns default sheet name" do
          assert_nil subject.new.name
        end

        it "accepts optional name" do
          assert_equal 'MySheet', subject.new(:name => 'MySheet').name
        end
      end

      describe "default_features" do
        it "returns default features" do
          assert_nil subject.new.features
        end

        it "accepts optional features" do
          assert_equal [:filter], subject.new(:features => [:filter]).features
        end
      end

      describe "columns" do
        it "raises without default_columns" do
          assert_raises Bureau::Errors::MissingDefaultColumnsError do
            subject_without_default_columns.new
          end
        end

        it "returns default columns" do
          assert_equal Bureau::Table::BaseTest.columns, subject.new.columns
        end

        it "acceptss optional columns" do
          columns = [Bureau::Column::Base.new('foo','FOO',:string)]

          assert_equal columns, subject.new(:columns => columns).columns
        end
      end

      describe "header" do
        it "wraps columns in cell presenter" do
          columns  = [
            Bureau::Column::Base.new('foo','FOO',:string),
            Bureau::Column::Base.new('bar','BAR'),
            Bureau::Column::Base.new('baz')
          ]

          instance = subject.new(:columns => columns)

          assert_equal 3, instance.headers.size

          assert_equal 'FOO', instance.headers[0].value
          assert_equal :string, instance.headers[0].type

          assert_equal 'BAR', instance.headers[1].value
          assert_equal nil, instance.headers[1].type

          assert_equal 'Baz', instance.headers[2].value
          assert_equal nil, instance.headers[2].type
        end
      end

      describe "rows" do
        it "wraps columns in cell presenter" do
          collection = [Object.new]
          columns    = [
            Bureau::Column::Base.new('foo','FOO',:string),
            Bureau::Column::Base.new('bar','BAR'),
            Bureau::Column::Base.new('baz')
          ]

          instance = subject.new(:columns => columns, :collection => collection, :row_presenter => row_presenter)

          assert_equal 1, instance.rows.size

          assert_equal 'foo', instance.rows[0][0].value
          assert_equal :string, instance.rows[0][0].type

          assert_equal 1, instance.rows[0][1].value
          assert_equal nil, instance.rows[0][1].type

          assert_equal 'baz', instance.rows[0][2].value
          assert_equal nil, instance.rows[0][2].type
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
            ::Bureau::Table::BaseTest.columns
          end
        end
      end

      def self.columns
        @columns ||= [
          Bureau::Column::Base.new('foo','FOO',:string),
          Bureau::Column::Base.new('bar','BAR')
        ]
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

          def baz
            'baz'
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
