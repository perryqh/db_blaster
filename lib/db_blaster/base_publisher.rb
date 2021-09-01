# frozen_string_literal: true

# publish records to SNS topic
module DbBlaster
  # Base class for publishing
  class BasePublisher
    attr_reader :source_table, :records, :batch_start_time

    def initialize(source_table, records, batch_start_time)
      @source_table = source_table
      @records = records
      @batch_start_time = batch_start_time
    end

    def self.publish(source_table:, records:, batch_start_time:)
      publisher_class =
        if DbBlaster.configuration.sns_topic
          SnsPublisher
        else
          S3Publisher
        end
      publisher_class.new(source_table, records, batch_start_time).publish
    end

    def publish
      raise NotImplementedError
    end
  end
end
