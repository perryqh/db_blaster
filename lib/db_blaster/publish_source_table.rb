# frozen_string_literal: true

module DbBlaster
  class PublishSourceTable
    attr_reader :source_table

    def initialize(source_table)
      @source_table = source_table
    end

    def self.execute(source_table)
      new(source_table).execute
    end

    def execute
      DbBlaster.configuration.verify!

      source_table.with_lock do
        RecordsForSourceTable.find(source_table) do |records|
          Publisher.publish(source_table, records)
          source_table.update(last_published_updated_at: records.last['updated_at'])
        end
      end
      self
    end
  end
end
