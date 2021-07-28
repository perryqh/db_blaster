module DbBlaster
  class PublishSourceTableJob < ApplicationJob
    queue_as 'default'

    def perform(source_table_id)
      source_table = SourceTable.find_by(id: source_table_id)
      return unless source_table

      PublishSourceTable.execute(source_table)
    end
  end
end