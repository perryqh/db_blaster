# frozen_string_literal: true

# Executes PublishSourceTable for provided `source_table_id`
module DbBlaster
  # Publishes changed rows to SNS
  class PublishSourceTableJob < ApplicationJob
    queue_as 'default'

    def perform(source_table_id, batch_start_time)
      source_table = SourceTable.find_by(id: source_table_id)
      return unless source_table

      PublishSourceTable.execute(source_table: source_table, batch_start_time: batch_start_time)
    end
  end
end
