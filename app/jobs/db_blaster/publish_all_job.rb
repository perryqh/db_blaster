# frozen_string_literal: true

# Job that will
# 1) sync DbBlaster.configuration.source_tables with DbBlaster::SourceTable
# 2) Enqueue PublishSourceTableJob for every source_table
module DbBlaster
  class PublishAllJob < ApplicationJob
    queue_as 'default'

    def perform
      SourceTable.sync(DbBlaster.configuration.source_tables || [])

      DbBlaster::SourceTable.pluck(:id).each do |source_table_id|
        PublishSourceTableJob.perform_later(source_table_id)
      end
    end
  end
end
