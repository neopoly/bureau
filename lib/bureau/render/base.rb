module Bureau
  module Render
    class Base

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
          sheet.add_row header.map(&:value)

          rows.each do |row|
            values = row.map(&:value)
            types  = row.map(&:type)

            sheet.add_row values, :types => types
          end
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
  end
end
