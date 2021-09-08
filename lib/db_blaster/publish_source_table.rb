# frozen_string_literal: true

module DbBlaster
  # Given a `source_table` providing the table name,
  # finds rows in `batch_size` chunks that are published to SNS
  class PublishSourceTable
    attr_reader :source_table, :batch_start_time

    def initialize(source_table, batch_start_time)
      @source_table = source_table
      @batch_start_time = batch_start_time
    end

    def self.execute(source_table:, batch_start_time:)
      new(source_table, batch_start_time).execute
    end

    def execute
      DbBlaster.configuration.verify! # will raise error if required configurations are not set

      # pessimistically lock row for the duration
      source_table.with_lock do
        Finder.find(source_table) do |records|
          BasePublisher.publish(source_table: source_table, records: records, batch_start_time: batch_start_time)
          source_table.update(last_published_updated_at: records.last['updated_at'],
                              last_published_id: records.last['id'])
        end
      end
      self
    end
  end
end
