# frozen_string_literal: true

module DbBlaster
  class SourceTableConfiguration
    attr_reader :source_table_name, :batch_size, :ignored_column_names

    def initialize(params)
      params.each_key do |key|
        instance_variable_set("@#{key}", params[key])
      end
    end

    def update_attributes
      { batch_size: batch_size,
        ignored_columns: ignored_column_names }
    end
  end
end
