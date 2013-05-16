module Bureau
  module Render
    module Base

      module InstanceMethods
        attr_reader :header, :rows, :name

        def initialize(header, rows, options = {})
          @header       = header
          @rows         = rows
          @feature_list = options.fetch(:features, default_features)
          @name         = options.fetch(:name, default_name)
        end

        def render
          apply_features!
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

        def features
          @features ||= Bureau::Features::Collection.new(self)
        end

        # TODO: Integrationtest
        def to_xlsx
          package.to_stream().read
        end

        private

        def feature_list
          @feature_list
        end

        def apply_features!
          feature_list.each { |feat| features.add(feat) }
          features.apply!
        end

        def default_features
          [:filter, :docked]
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
