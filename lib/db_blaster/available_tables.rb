# frozen_string_literal: true

module DbBlaster
  # Finds all tables in current database and removes the "system tables"
  module AvailableTables
    SYSTEM_TABLES = %w[schema_migrations ar_internal_metadata].freeze

    def available_tables
      @available_tables ||= ActiveRecord::Base.connection.tables - SYSTEM_TABLES
    end
  end
end
