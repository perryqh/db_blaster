# frozen_string_literal: true

# Either `sns_topic` or `s3_bucket` must be set
DbBlaster.configure do |config|
  # SNS topic to receive database changes. Either `sns_topic` or `s3_bucket` must be set
  config.sns_topic = 'the-topic'
  config.aws_access_key = 'access-key'
  config.aws_access_secret = 'secret'
  config.aws_region = 'region'

  # Optional
  # Applicable only when `sns_topic` is set
  # Extra [SNS message_attributes](https://docs.aws.amazon.com/sns/latest/dg/sns-message-attributes.html)
  # Attributes set here will be included in every published message
  # config.extra_sns_message_attributes = {'infra_id' => {data_type: 'String', value: '061'}}

  # S3 bucket where JSON will be pushed. Either `sns_topic` or `s3_bucket` must be set
  # config.s3_bucket = 'bucket-name'

  # Optional
  # Applicable only when `s3_bucket` is set
  # The S3 key path. The following values will get substituted:
  # <batch_date_time> - a timestamp signifying the beginning of the batch processing
  # <batch_date> - a date signifying the beginning of the batch processing
  # <batch_time> - a time signifying the beginning of the batch processing
  # <timestamp> - the current time
  # <table_name> - the name of the table associated with the S3 body
  # <uuid> - a universal identifier
  # config.s3_key = '<batch_timestamp>/kcp-api/001/<table_name>/<uuid>.json'

  # Optional
  # Applicable only when `s3_bucket' is set
  # Extra meta values sent along with each payload
  # example: config.s3_meta = {'infra_id' => '061'}
  # The resulting JSON will include the `meta` merged into every record.
  # config.s3_meta = {'infra_id' => '061'}

  # Optional
  # db_blaster will select and then publish `batch_size` rows at a time
  # config.batch_size = 100

  # Optional
  # db_blaster will publish no messages larger than this value
  # Default value is 256
  # config.max_message_size_in_kilobytes = 256

  # Global list of column names not to include in published SNS messages
  # example: config.ignored_column_names = ['email', 'phone_number']
  # config.ignored_column_names = ['email', 'phone_number']

  # Optional
  # If set, only publish tables specified.
  # config.only_source_tables = ['posts', 'tags', 'comments']

  # Optional
  # If set, ignore source tables specified.
  # config.ignore_source_tables = ['active_storage_blobs']

  # Optional
  # Customize batch_size and/or ignored_columns
  # example:
  # config.source_table_options = [{ source_table_name: 'posts', batch_size: 100, ignored_column_names: ['email'] },
  #                                { source_table_name: 'comments', ignored_column_names: ['tags'] }]
end
