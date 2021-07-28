DbBlaster.configure do |config|
  # SNS topic to receive database changes
  config.sns_topic = 'the-topic'
  config.aws_access_key = 'access-key'
  config.aws_access_secret = 'secret'
  config.aws_region = 'region'

  # Optional
  # db_blaster will select and then publish `batch_size` rows at a time
  # config.batch_size = 100

  # Optional
  # Extra [SNS message_attributes](https://docs.aws.amazon.com/sns/latest/dg/sns-message-attributes.html)
  # Attributes set here will be included in every published message
  # config.extra_sns_message_attributes = {'infra_id' => {data_type: 'String', value: '061'}}

  # Global list of column names not to include in published SNS messages
  # example: config.ignored_column_names = ['email', 'phone_number']
  # config.ignored_column_names = ['email', 'phone_number']

  config.source_tables = [{ name: 'table-1',
                            ignored_columns: [],
                            batch_size: 100 }] # tables to be pushed to SNS
end