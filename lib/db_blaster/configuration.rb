# frozen_string_literal: true

module DbBlaster
  # Configuration class for providing credentials, topics, and customizations.
  # Either the `sns_topic` or `s3_bucket' must be set
  class Configuration
    DEFAULT_BATCH_SIZE = 100
    DEFAULT_MAX_MESSAGE_SIZE_IN_KILOBYTES = 256 # max size allowed by AWS SNS
    DEFAULT_S3_KEY = '<batch_date>/<batch_time>/db_blaster/<table_name>/<uuid>.json'
    DEFAULT_DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%LZ'

    # The required configuration fields
    REQUIRED_FIELDS = %i[aws_access_key aws_access_secret aws_region].freeze

    # exactly one of these fields needs to be set
    EITHER_OR_FIELDS = %i[sns_topic s3_bucket].freeze

    # The topic to which messages will be published
    attr_accessor :sns_topic
    # The s3 bucket name
    attr_accessor :s3_bucket
    attr_accessor :aws_access_key, :aws_access_secret, :aws_region

    # Optional
    # Applicable only when `sns_topic` is set
    # Extra [SNS message_attributes](https://docs.aws.amazon.com/sns/latest/dg/sns-message-attributes.html)
    # Attributes set here will be included in every published message
    # example: config.extra_sns_message_attributes = {'infra_id' => {data_type: 'String', value: '061'}}
    attr_accessor :extra_sns_message_attributes

    # Optional
    # Applicable only when `s3_bucket' is set
    # The value set here will be included in every payload pushed to S3
    # example: config.s3_meta = {'infra_id' => '061', 'source_app' => 'kcp-api'}}
    # The resulting JSON will include the `meta` merged into every record
    attr_accessor :s3_meta

    # Optional
    # Applicable only when `s3_bucket` is set
    # The S3 key. The following values will get substituted:
    # <batch_timestamp> - a timestamp signifying the beginning of the batch processing
    # <timestamp> - the current time
    # <table_name> - the name of the table associated with the S3 body
    # <uuid> - a universal identifier
    # '<batch_timestamp>/kcp-api/001/<table_name>/<uuid>.json'
    attr_accessor :s3_key

    # Optional
    # Applicable only when `s3_bucket` is set
    # S3 Tags
    # example: config.s3_tags = { infra_id: '001', source_app: 'kcp-api', source_table: 'meetings' }
    attr_accessor :s3_tags

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
    # db_blaster will select and then publish `batch_size` rows at a time
    # Default value is 100
    attr_accessor :batch_size

    # Optional
    # DbBlaster will publish no messages larger than this value
    # Default value is 256
    attr_accessor :max_message_size_in_kilobytes

    # Raises error if a required field is not set
    def verify!
      verify_required
      verify_either_or
    end

    def verify_either_or
      either_or = EITHER_OR_FIELDS.select do |attribute|
        send(attribute).nil? || send(attribute).strip.empty?
      end
      raise "only one of [#{either_or.join(', ')}] should be set" unless either_or.length == 1
    end

    def verify_required
      no_values = REQUIRED_FIELDS.select do |attribute|
        send(attribute).nil? || send(attribute).strip.empty?
      end
      raise "missing configuration values for [#{no_values.join(', ')}]" unless no_values.empty?
    end
  end
end
