module Bureau
  module Render
    module Base

      module InstanceMethods
        attr_reader :header, :rows

        def initialize(options = {})
          @header = options[:header]
          @rows   = options[:rows]
        end

        def render
          features.add(:filter)
          features.apply!
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
          @worksheet ||= workbook.add_worksheet do |sheet|
            sheet.add_row header.map { |column| column.value }
            rows.each { |row| sheet.add_row row.map { |column| column.value } }
          end
        end

        def features
          @features ||= Bureau::Features::Base.new(self)
        end

        # TODO: Integrationtest
        def to_xlsx
          package.to_stream().read
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
