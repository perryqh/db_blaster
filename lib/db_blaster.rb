# frozen_string_literal: true

require 'aws-sdk-sns'
require 'db_blaster/version'
require 'db_blaster/engine'
require 'db_blaster/configuration'
require 'db_blaster/publisher'
require 'db_blaster/publish_source_table'
require 'db_blaster/records_for_source_table'

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
