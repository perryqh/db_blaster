# frozen_string_literal: true

module DbBlaster
  # Given a `source_table` providing the table name,
  # finds rows in `batch_size` chunks that are published to SNS
  class PublishSourceTable
    attr_reader :source_table

    def initialize(source_table)
      @source_table = source_table
    end

    def self.execute(source_table)
      new(source_table).execute
    end

    def execute
      DbBlaster.configuration.verify! # will raise error if required configurations are not set

      # pessimistically lock row for the duration
      source_table.with_lock do
        Finder.find(source_table) do |records|
          Publisher.publish(source_table, records)
          source_table.update(last_published_updated_at: records.last['updated_at'])
        end
      end
      self
    end
  end
end
