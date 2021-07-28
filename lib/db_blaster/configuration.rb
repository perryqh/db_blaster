# frozen_string_literal: true

module DbBlaster
  class Configuration
    REQUIRED_FIELDS = %i[aws_access_key aws_access_secret aws_region sns_topic].freeze

    # The topic to which messages will be published
    attr_accessor :sns_topic
    attr_accessor :aws_access_key, :aws_access_secret, :aws_region
    attr_accessor :source_tables # [{name: 'source_table_name', batch_size: 'optional_batch_size', ignored_columns: ['optional_ignored_columns']}]

    # extra SNS message_attributes
    # example: {'infra_id' => {data_type: 'String', value: '061'}}
    attr_accessor :extra_sns_message_attributes

    def verify!
      no_values = REQUIRED_FIELDS.select do |attribute|
        send(attribute).nil? || send(attribute).strip.empty?
      end
      return if no_values.empty?

      raise "missing configuration values for [#{no_values.join(', ')}]"
    end
  end
end
