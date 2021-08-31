# frozen_string_literal: true

# publish records to SNS topic
module DbBlaster
  # Base class for publishing
  class Publisher
    attr_reader :source_table, :records

    def initialize(source_table, records)
      @source_table = source_table
      @records = records
    end

    def self.publish(source_table, records)
      SnsPublisher.new(source_table, records).publish
    end

    def publish
      raise NotImplementedError
    end
  end
end
