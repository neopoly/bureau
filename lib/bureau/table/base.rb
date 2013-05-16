require 'bureau/errors'
require 'active_support/ordered_hash'

module Bureau
  module Table
    module Base

      module InstanceMethods
        include Errors

        attr_reader :collection, :row_presenter, :cell_presenter, :renderer

        def initialize(options = {})
          @row_presenter  = options.fetch(:row_presenter, default_row_presenter)
          @cell_presenter = options.fetch(:cell_presenter, default_cell_presenter)
          @renderer       = options.fetch(:renderer, default_renderer)
          @attributes     = options.fetch(:attributes, default_attributes)
          @collection     = options.fetch(:collection, default_collection).map {|item| row_presenter.new(item)}
          raise EmptyCollectionError if @collection.empty?
        end

        def header
          attributes.map { |key, value| cell_presenter.new(value) }
        end

        def rows
          collection.map do |person|
            attributes.inject([]) do |columns, (key, value)|
              columns << cell_presenter.new(person.send(key))
              columns
            end
          end
        end

        def attributes
          ActiveSupport::OrderedHash.new().merge(
            if @attributes.kind_of?(Hash)
              @attributes
            else
              @attributes.inject({}) do |hash, (key, value)|
                hash[key] = default_attributes[key]
                hash
              end
            end
          )
        end

        def render
          renderer.new(header, rows).render
        end

        private

        def default_row_presenter
          Class.new { include Bureau::Row::Base }
        end

        def default_cell_presenter
          Class.new { include Bureau::Cell::Base }
        end

        def default_renderer
          Class.new { include Bureau::Render::Base }
        end

        def default_attributes
          raise MissingDefaultAttributesError.new("Implement default_attributes")
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
