module Bureau
  module Render
    module Base

      module InstanceMethods
        attr_reader :header, :rows, :name, :features, :collection

        def initialize(header, rows, options = {})
          @header     = header
          @rows       = rows
          @name       = options[:name] || default_name
          @features   = options[:features] || default_features
          @collection = Bureau::Features::Collection.new(self)
        end

        def render
          features.each { |feature| collection.add(feature) }
          collection.apply!
          to_xlsx
        end

        def package
          @package ||= Axlsx::Package.new
        end

        def workbook
          @workbook ||= package.workbook
        end

        # TODO: Support multiple worksheets
        def worksheet
          @worksheet ||= workbook.add_worksheet(:name => name) do |sheet|
            sheet.add_row header.map { |column| column.value }
            rows.each { |row| sheet.add_row row.map { |column| column.value } }
          end
        end

        # TODO: Integrationtest
        def to_xlsx
          package.to_stream().read
        end

        private

        def default_features
          [ Bureau::Features::Filter, Bureau::Features::Docked ]
        end

        def default_name
          "Sheet"
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
