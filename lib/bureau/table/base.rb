require 'bureau/errors'
require 'active_support/ordered_hash'

module Bureau
  module Table
    module Base

      module InstanceMethods
        include Errors

        attr_reader :collection, :row_presenter, :cell_presenter, :renderer, :name, :features, :columns

        def initialize(options = {})
          @row_presenter  = options[:row_presenter] || default_row_presenter
          @cell_presenter = options[:cell_presenter] || default_cell_presenter
          @renderer       = options[:renderer] || default_renderer
          @columns        = options[:columns] || default_columns
          @collection     = (options[:collection] || default_collection).map {|item| row_presenter.new(item)}
          raise EmptyCollectionError if @collection.empty?
          @name           = options[:name] || default_name
          @features       = options[:features] || default_features
        end

        def headers
          columns.map do |column|
            cell_presenter.new(column.label, column.type)
          end
        end

        def rows
          collection.map do |person|
            columns.map do |column|
              cell_presenter.new(person.send(column.key), column.type)
            end
          end
        end

        # TODO: Test me!
        def render
          renderer.new(headers, rows, :name => name, :features => features).render
        end

        def default_name
          nil
        end

        def default_features
          nil
        end

        def default_row_presenter
          Class.new { include Bureau::Row::Base }
        end

        def default_cell_presenter
          Class.new { include Bureau::Cell::Base }
        end

        def default_renderer
          Bureau::Render::Base
        end

        def default_columns
          raise MissingDefaultColumnsError.new("Implement default_columns")
        end

        def default_collection
          raise MissingDefaultCollectionError.new("Implement default_collection")
        end

      end

      module ClassMethods
      end

      def included(mod)
        mod.extend ClassMethods
      end

      include InstanceMethods

    end
  end
end
