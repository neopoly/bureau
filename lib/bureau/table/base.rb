require 'bureau/errors'
require 'axlsx'

module Bureau
  module Table
    module Base

      module InstanceMethods
        include Errors

        attr_reader :collection, :row_presenter, :cell_presenter, :renderer

        def initialize(options = {})
          raise MissingDefaultAttributesError.new("Implement default_attributes") unless respond_to? :default_attributes
          @attributes     = options.fetch(:attributes, default_attributes)

          raise MissingDefaultCollectionError.new("Implement default_collection") unless respond_to? :default_collection
          @collection     = options.fetch(:collection, default_collection)

          raise EmptyCollectionError                                              if collection.empty?

          @row_presenter  = options.fetch(:row_presenter, default_row_presenter)
          @cell_presenter = options.fetch(:cell_presenter, default_cell_presenter)
          @renderer       = options.fetch(:renderer, default_renderer)

          @collection     = collection.map do |item|
            row_presenter.new(item)
          end
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
          if @attributes.kind_of?(Hash)
            @attributes
          else
            @attributes.inject({}) do |hash, (key, value)|
              hash[key] = default_attributes[key]
              hash
            end
          end
        end

        def render
          renderer.new(:header => header, :rows => rows).render
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
