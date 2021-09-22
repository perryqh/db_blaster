# frozen_string_literal: true

module DbBlaster
  # Builds an array of tables and their columns
  class SourceTablesSchemaBuilder
    def self.build_schema
      new.build_schema
    end

    def build_schema
      SyncSourceTablesWithConfiguration.sync

      DbBlaster::SourceTable.all.each_with_object({}) do |source_table, hash|
        hash[source_table.name] = build_columns_from_source_table(source_table)
      end
    end

    def build_columns_from_source_table(source_table)
      ActiveRecord::Base.connection.columns(source_table.name).collect do |column|
        next if source_table.ignored_columns.include?(column.name)

        { name: column.name,
          type: column.type,
          limit: column.limit }
      end.compact
    end
  end
end
