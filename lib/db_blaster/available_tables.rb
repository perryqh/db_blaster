module DbBlaster
  module AvailableTables
    SYSTEM_TABLES = %w[schema_migrations ar_internal_metadata]

    def available_tables
      @available_tables ||= ActiveRecord::Base.connection.tables - SYSTEM_TABLES
    end
  end
end