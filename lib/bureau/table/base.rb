require 'bureau/errors'
require 'active_support/ordered_hash'

module Bureau
  module Table
    module Base

      module InstanceMethods
        include Errors

        attr_reader :collection, :row_presenter, :cell_presenter, :renderer, :name, :features

        def initialize(options = {})
          @row_presenter  = options[:row_presenter] || default_row_presenter
          @cell_presenter = options[:cell_presenter] || default_cell_presenter
          @renderer       = options[:renderer] || default_renderer
          @attributes     = options[:attributes] || default_attributes
          @collection     = (options[:collection] || default_collection).map {|item| row_presenter.new(item)}
          raise EmptyCollectionError if @collection.empty?
          @name           = options[:name] || default_name
          @features       = options[:features] || default_features
        end

        def header
          attributes.map { |key, value| cell_presenter.new(value) }
        end

        def rows
          collection.map do |person|
            attributes.map do |key, value|
              cell_presenter.new(person.send(key))
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
          renderer.new(header, rows, :name => name, :features => features).render
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
