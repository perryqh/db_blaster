# frozen_string_literal: true

require 'aws-sdk-s3'

module DbBlaster
  # Pushes records to S3
  class S3Publisher < BasePublisher
    def publish
      client.put_object(bucket: DbBlaster.configuration.s3_bucket,
                        key: S3KeyBuilder.build(source_table_name: source_table.name,
                                                batch_start_time: batch_start_time),
                        body: content.to_json)
    end

    def content
      { meta: meta,
        records: records }
    end

    def meta
      (DbBlaster.configuration.s3_meta || {}).merge(source_table: source_table.name)
    end

    def client
      @client ||= Aws::S3::Client.new(region: DbBlaster.configuration.aws_region,
                                      credentials: Aws::Credentials.new(DbBlaster.configuration.aws_access_key,
                                                                        DbBlaster.configuration.aws_access_secret))
    end
  end
end
