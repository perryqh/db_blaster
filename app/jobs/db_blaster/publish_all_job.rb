# frozen_string_literal: true

# ActiveJob
# 1) sync configuration with DbBlaster::SourceTable
# 2) Enqueue PublishSourceTableJob for every source_table
module DbBlaster
  # Enqueues PublishSourceTableJob for every source-table
  class PublishAllJob < ApplicationJob
    queue_as 'default'

    def perform
      SourceTable.sync(SourceTableConfigurationBuilder
                         .build_all(DbBlaster.configuration))

      DbBlaster::SourceTable.pluck(:id).each do |source_table_id|
        PublishSourceTableJob.perform_later(source_table_id, batch_start_time)
      end
    end

    def batch_start_time
      @batch_start_time ||= DateTime.now.utc.strftime(DbBlaster::Configuration::DEFAULT_DATETIME_FORMAT)
    end
  end
end
