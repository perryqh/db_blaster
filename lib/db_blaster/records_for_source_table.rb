# frozen_string_literal: true

module DbBlaster
  class RecordsForSourceTable
    attr_reader :source_table, :block_on_find

    def initialize(source_table, &block)
      @source_table = source_table
      @block_on_find = block
      @offset = 0
    end

    def self.find(source_table, &block)
      new(source_table, &block).find
    end

    def find
      find_records_in_batches do |batch|
        block_on_find.call(batch.collect(&method(:filter_columns)))
      end
    end

    private

    def find_records_in_batches
      sql = "SELECT * FROM #{source_table.name} #{where} ORDER BY updated_at ASC LIMIT #{source_table.batch_size}"
      offset = 0

      loop do
        result = ActiveRecord::Base.connection.execute("#{sql} OFFSET #{offset}")
        yield(result)
        break if result.count != source_table.batch_size

        offset += source_table.batch_size
      end
    end

    def filter_columns(selected_row)
      selected_row.except(*source_table.ignored_columns)
    end

    def where
      return '' unless source_table.last_published_updated_at

      "WHERE updated_at > '#{source_table.last_published_updated_at.to_s(:db)}'"
    end

    def formatted_timestamp
      "'#{source_table.last_published_updated_at}' at time zone 'utc'"
    end
  end
end
