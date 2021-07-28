# frozen_string_literal: true

# ActiveJob
# 1) sync configuration with DbBlaster::SourceTable
# 2) Enqueue PublishSourceTableJob for every source_table
module DbBlaster
  class PublishAllJob < ApplicationJob
    queue_as 'default'

    def perform
      SourceTable.sync(SourceTableConfigurationBuilder
                         .build_all(DbBlaster.configuration))

      DbBlaster::SourceTable.pluck(:id).each do |source_table_id|
        PublishSourceTableJob.perform_later(source_table_id)
      end
    end
  end
end
