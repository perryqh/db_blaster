# frozen_string_literal: true

module DbBlaster
  # Builds source-table configurations based off the tables in the
  # current database and the provided DbBlaster::Configuration
  class SourceTableConfigurationBuilder
    attr_reader :configuration, :source_table_configurations

    def initialize(configuration)
      @configuration = configuration
      @source_table_configurations = []
    end

    def self.build_all(configuration)
      new(configuration).build_all
    end

    def build_all
      @build_all ||= table_names_for_configuration
                     .collect(&method(:build_configuration))
    end

    def build_configuration(source_table_name)
      SourceTableConfiguration.new(source_table_name: source_table_name,
                                   batch_size: batch_size(source_table_name),
                                   ignored_column_names: ignored_column_names(source_table_name))
    end

    def batch_size(source_table_name)
      overridden_value_or_global(source_table_name, :batch_size) || configuration.default_batch_size
    end

    def ignored_column_names(source_table_name)
      overridden_value_or_global(source_table_name, :ignored_column_names) || []
    end

    def overridden_value_or_global(source_table_name, field_name)
      find_source_table_options(source_table_name)&.send(:[], field_name) || configuration.send(field_name)
    end

    def find_source_table_options(source_table_name)
      (configuration.source_table_options || [])
        .detect { |option| option[:source_table_name] == source_table_name }
    end

    def table_names_for_configuration
      if !configuration.only_source_tables.nil? && configuration.only_source_tables.length.positive?
        available_tables & configuration.only_source_tables
      else
        available_tables
      end
    end

    def available_tables
      @available_tables ||= ActiveRecord::Base.connection.tables - configuration.global_ignore_tables
    end
  end
end
