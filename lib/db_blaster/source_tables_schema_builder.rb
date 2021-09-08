# frozen_string_literal: true

module DbBlaster
  # Builds an array of tables and their columns
  class SourceTablesSchemaBuilder
    def self.build_schema
      new.build_schema
    end

    def build_schema
      ActiveRecord::Base.connection.tables.each_with_object({}) do |table_name, hash|
        unless AvailableTables::SYSTEM_TABLES.include?(table_name)
          hash[table_name] = build_columns_from_table_name(table_name)
        end
      end
    end

    def build_columns_from_table_name(table_name)
      ActiveRecord::Base.connection.columns(table_name).collect do |column|
        next if ignored_column?(column.name)

        { name: column.name,
          type: column.type,
          limit: column.limit }
      end.compact
    end

    def ignored_column?(column)
      (DbBlaster.configuration.ignored_column_names || []).include?(column)
    end
  end
end
