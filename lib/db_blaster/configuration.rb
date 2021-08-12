# frozen_string_literal: true

module DbBlaster
  # Configuration class for providing credentials, topics, and customizations.
  class Configuration
    DEFAULT_BATCH_SIZE = 100
    DEFAULT_MAX_MESSAGE_SIZE_IN_KILOBYTES = 256 # max size allowed by AWS SNS

    # The required configuration fields
    REQUIRED_FIELDS = %i[aws_access_key aws_access_secret aws_region sns_topic].freeze

    # The topic to which messages will be published
    attr_accessor :sns_topic
    attr_accessor :aws_access_key, :aws_access_secret, :aws_region

    # Global list of column names not to include in published SNS messages
    # example: config.ignored_column_names = ['email', 'phone_number']
    attr_accessor :ignored_column_names

    # Optional
    # If set, only publish tables specified.
    # example: config.only_source_tables = ['posts', 'tags', 'comments']
    attr_accessor :only_source_tables

    # Optional
    # If set, ignore source tables specified.
    # example: config.ignore_source_tables = ['active_storage_blobs']
    attr_accessor :ignore_source_tables

    # Optional
    # Customize batch_size and/or ignored_columns
    # example:
    # config.source_table_options = [{ source_table_name: 'posts', batch_size: 100, ignored_column_names: ['email'] },
    #                                { source_table_name: 'comments', ignored_column_names: ['tags'] }]
    attr_accessor :source_table_options

    # Optional
    # Extra [SNS message_attributes](https://docs.aws.amazon.com/sns/latest/dg/sns-message-attributes.html)
    # Attributes set here will be included in every published message
    # example: config.extra_sns_message_attributes = {'infra_id' => {data_type: 'String', value: '061'}}
    attr_accessor :extra_sns_message_attributes

    # Optional
    # db_blaster will select and then publish `batch_size` rows at a time
    # Default value is 100
    attr_accessor :batch_size

    # Optional
    # DbBlaster will publish no messages larger than this value
    # Default value is 256
    attr_accessor :max_message_size_in_kilobytes

    # Raises error if a required field is not set
    def verify!
      no_values = REQUIRED_FIELDS.select do |attribute|
        send(attribute).nil? || send(attribute).strip.empty?
      end
      return if no_values.empty?

      raise "missing configuration values for [#{no_values.join(', ')}]"
    end
  end
end
