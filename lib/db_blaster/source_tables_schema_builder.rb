# frozen_string_literal: true

module DbBlaster
  # Builds an array of tables and their columns
  module SourceTablesSchemaBuilder
    def self.build_schema
      ActiveRecord::Base.connection.tables.each_with_object({}) do |table_name, hash|
        unless AvailableTables::SYSTEM_TABLES.include?(table_name)
          hash[table_name] = build_columns_from_table_name(table_name)
        end
      end
    end

    def self.build_columns_from_table_name(table_name)
      ActiveRecord::Base.connection.columns(table_name).collect do |column|
        { name: column.name,
          type: column.type,
          limit: column.limit }
      end
    end
  end
end
