# frozen_string_literal: true

# Syncs tables derived from SourceTableConfigurationBuilder
# with SourceTable rows
module DbBlaster
  module Sync
    extend ActiveSupport::Concern

    class_methods do
      # Syncs configuration tables with db
      def sync(table_configs)
        SourceTable.where.not(name: table_configs.collect(&:source_table_name)).delete_all

        table_configs.each do |config|
          source_table = SourceTable.where(name: config.source_table_name).first_or_create
          source_table.update!(config.update_attributes)
        end
      end
    end
  end
end
