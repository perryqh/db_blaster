# frozen_string_literal: true

module DbBlaster
  # Find records and yield them a `batch_size` at a time
  class Finder
    include AvailableTables
    attr_reader :source_table, :block_on_find, :offset

    def initialize(source_table, &block)
      @source_table = source_table
      @block_on_find = block
      @offset = 0
    end

    delegate :batch_size, :name, to: :source_table, prefix: true

    def self.find(source_table, &block)
      new(source_table, &block).find
    end

    def find
      verify_source_table_name

      find_records_in_batches do |batch|
        filtered = batch.collect(&method(:filter_columns))
        next if filtered.blank?

        Chunker.chunk(source_table, filtered) do |chunked|
          block_on_find.call(chunked)
        end
      end
    end

    private

    def find_records_in_batches
      select_sql = FinderSql.sql_for_source_table(source_table)
      loop do
        result = ActiveRecord::Base.connection.execute("#{select_sql} OFFSET #{offset}")
        yield(result)
        break if result.count != source_table_batch_size

        @offset += source_table_batch_size
      end
    end

    def filter_columns(selected_row)
      selected_row.except(*source_table.ignored_columns)
    end

    def verify_source_table_name
      raise invalid_source_table_message unless available_tables.include?(source_table_name)
    end

    def invalid_source_table_message
      "source_table.name: '#{source_table_name}' does not exist!"
    end
  end
end
