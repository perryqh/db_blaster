# frozen_string_literal: true

require 'aws-sdk-s3'

module DbBlaster
  # Pushes records to S3
  class S3Publisher < BasePublisher
    def publish
      client.put_object(bucket: DbBlaster.configuration.s3_bucket,
                        key: S3KeyBuilder.build(source_table_name: source_table.name,
                                                batch_start_time: batch_start_time),
                        tagging: tagging,
                        body: content.to_json)
    end

    def content
      return meta_records if DbBlaster.configuration.s3_meta_format == Configuration::INLINE_S3_META_FORMAT

      { meta: meta,
        records: records }
    end

    def tagging
      URI.encode_www_form(tags_hash)
    end

    def tags_hash
      @tags_hash ||= { source_table: source_table.name }
                     .merge(DbBlaster.configuration.s3_tags.presence || {})
    end

    def meta
      @meta ||= (DbBlaster.configuration.s3_meta.presence || {}).merge(source_table: source_table.name)
    end

    def meta_records
      records.collect { |record| record.merge(meta) }
    end

    def client
      @client ||= Aws::S3::Client.new(region: DbBlaster.configuration.aws_region,
                                      credentials: Aws::Credentials.new(DbBlaster.configuration.aws_access_key,
                                                                        DbBlaster.configuration.aws_access_secret))
    end
  end
end
