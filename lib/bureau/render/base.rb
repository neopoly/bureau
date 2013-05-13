module Bureau
  module Render
    module Base

      module InstanceMethods
        attr_reader :header, :rows

        def initialize(options = {})
          @header = options[:header]
          @rows   = options[:rows]
        end

        # TODO: test & refactor me!
        def render
          package   = Axlsx::Package.new
          workbook  = package.workbook
          workbook.add_worksheet(:name => "Teilnehmer Export") do |sheet|
            sheet.add_row header.map { |column| column.value }
            rows.each do |row|
              sheet.add_row row.map { |column| column.value }
            end
            sheet.auto_filter = "A1:AU1"
            sheet.sheet_view.pane do |pane|
              pane.top_left_cell = "B2"
              pane.state = :frozen_split
              pane.y_split = 1 # rows docked on top
              pane.x_split = 0 # rows docked left
            end
          end
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
