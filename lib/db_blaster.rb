# frozen_string_literal: true

require 'db_blaster/version'
require 'db_blaster/engine'
require 'db_blaster/one_record_too_large_error'
require 'db_blaster/available_tables'
require 'db_blaster/configuration'
require 'db_blaster/source_table_configuration'
require 'db_blaster/source_table_configuration_builder'
require 'db_blaster/base_publisher'
require 'db_blaster/s3_key_builder'
require 'db_blaster/s3_publisher'
require 'db_blaster/sns_publisher'
require 'db_blaster/publish_source_table'
require 'db_blaster/chunker'
require 'db_blaster/finder_sql'
require 'db_blaster/finder'

# Top-level module that serves as an entry point
# into the engine gem
module DbBlaster
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
