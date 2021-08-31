# frozen_string_literal: true

# publish records to SNS topic
module DbBlaster
  # Base class for publishing
  class BasePublisher
    attr_reader :source_table, :records

    def initialize(source_table, records)
      @source_table = source_table
      @records = records
    end

    def self.publish(source_table, records)
      if DbBlaster.configuration.sns_topic
        SnsPublisher.new(source_table, records).publish
      else
        S3Publisher.new(source_table, records).publish
      end
    end

    def publish
      raise NotImplementedError
    end
  end
end
