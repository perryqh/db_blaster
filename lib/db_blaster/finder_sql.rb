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

    # if we just use updated_at > from_updated_at, it's possible to miss records
    # that share the same `updated_at`
    # if we use updated_at >= from_updated_at, we'll get redundant records on every run
    # settled on the approach below
    def where
      return '' unless from_updated_at

      ActiveRecord::Base.sanitize_sql_for_conditions(
        ['WHERE updated_at > :updated_at OR (updated_at = :updated_at AND id <> :updated_id)',
         { updated_at: from_updated_at,
           updated_id: last_published_id }]
      )
    end

    def from_updated_at
      @from_updated_at ||= source_table.last_published_updated_at
    end

    def last_published_id
      @last_published_id ||= source_table.last_published_id
    end
  end
end
