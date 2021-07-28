# frozen_string_literal: true

# publish records to SNS topic
module DbBlaster
  class Publisher
    attr_reader :source_table, :records

    def initialize(source_table, records)
      @source_table = source_table
      @records = records
    end

    def self.publish(source_table, records)
      new(source_table, records).publish
    end

    def publish
      topic.publish(message_attributes: message_attributes,
                    message: records.to_json)
    end

    def topic
      resource.topic(DbBlaster.configuration.sns_topic)
    end

    def resource
      @resource ||= Aws::SNS::Resource.new(client: client)
    end

    def client
      @client ||= Aws::SNS::Client.new(region: DbBlaster.configuration.aws_region,
                                       credentials: Aws::Credentials.new(DbBlaster.configuration.aws_access_key,
                                                                         DbBlaster.configuration.aws_access_secret))
    end

    def message_attributes
      (DbBlaster.configuration.extra_sns_message_attributes || {})
        .merge('source_table' => { data_type: 'String', string_value: source_table.name })
    end
  end
end
