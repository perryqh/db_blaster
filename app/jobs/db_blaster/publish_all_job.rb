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