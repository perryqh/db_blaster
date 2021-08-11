# frozen_string_literal: true

module DbBlaster
  # Creates the SQL needed to find records for the provided source_table
  class FinderSql
    attr_reader :source_table

    def initialize(source_table)
      @source_table = source_table
    end

    def self.sql_for_source_table(source_table)
      new(source_table).select_sql
    end

    def select_sql
      "SELECT * FROM #{source_table.name} #{where} ORDER BY updated_at ASC LIMIT #{source_table.batch_size}"
    end

    def where
      return '' unless from_updated_at

      ActiveRecord::Base.sanitize_sql_for_conditions(
        ['WHERE updated_at >= :updated_at', { updated_at: from_updated_at.to_s(:db) }]
      )
    end

    def from_updated_at
      @from_updated_at ||= source_table.last_published_updated_at
    end
  end
end
