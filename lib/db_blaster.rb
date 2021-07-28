# frozen_string_literal: true

require 'aws-sdk-sns'
require 'db_blaster/version'
require 'db_blaster/engine'
require 'db_blaster/configuration'
require 'db_blaster/source_table_configuration'
require 'db_blaster/source_table_configuration_builder'
require 'db_blaster/publisher'
require 'db_blaster/publish_source_table'
require 'db_blaster/records_for_source_table'

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
