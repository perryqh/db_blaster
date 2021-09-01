# frozen_string_literal: true

require 'aws-sdk-s3'

module DbBlaster
  # Pushes records to S3
  class S3Publisher < BasePublisher
    def publish

    end

    # def upload_content
    #   client.put_object(bucket: DbBlaster.configuration.s3_bucket,
    #                     key: key,
    #                     body: content)
    # end
    #
    # def key
    #
    # end
    #
    # def client
    #   @client ||= Aws::S3::Client.new(region: DbBlaster.configuration.aws_region,
    #                                   credentials: Aws::Credentials.new(DbBlaster.configuration.aws_access_key,
    #                                                                     DbBlaster.configuration.aws_access_secret))
    # end
  end
end
