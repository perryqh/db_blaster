# frozen_string_literal: true

module DbBlaster
  # Builds the key to be used for the uploaded S3 Object
  class S3KeyBuilder
    attr_reader :source_table_name, :batch_start_time

    def initialize(source_table_name, batch_start_time)
      @source_table_name = source_table_name
      @batch_start_time = batch_start_time
    end

    def self.build(source_table_name:, batch_start_time:)
      new(source_table_name, batch_start_time).build
    end

    def build
      key = starting_key
      substitutions.each do |replace, value|
        key = key.gsub(replace, value)
      end
      key
    end

    def substitutions
      date, time = batch_start_time.split('T')
      { '<batch_date_time>' => batch_start_time,
        '<batch_date>' => date,
        '<batch_time>' => time,
        '<uuid>' => SecureRandom.uuid,
        '<table_name>' => source_table_name }
    end

    def starting_key
      DbBlaster.configuration.s3_key.presence || Configuration::DEFAULT_S3_KEY
    end
  end
end
