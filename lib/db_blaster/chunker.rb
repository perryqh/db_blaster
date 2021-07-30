# frozen_string_literal: true

module DbBlaster
  # Chunk the records into sizes < Configuration.max_message_size_in_kilobytes
  # yielding the chunks inline to the provided block
  # If the records' size is already less than Configuration.max_message_size_in_kilobytes,
  # all the records are yielded to the provided block
  class Chunker
    attr_reader :source_table, :records, :block_on_chunk, :current_chunk, :current_chunk_size

    def initialize(source_table, records, &block_on_chunk)
      @source_table = source_table
      @records = records
      @block_on_chunk = block_on_chunk
      @current_chunk_size = 0
      @current_chunk = []
    end

    def self.chunk(source_table, records, &block)
      new(source_table, records, &block).chunk
    end

    def chunk
      return if yield_if_records_acceptable?

      breakup_records
    end

    def yield_if_records_acceptable?
      return if records.to_json.size >= max_bytes

      block_on_chunk.call(records)
      true
    end

    def max_bytes
      @max_bytes ||= 1000 * max_kilobytes
    end

    def max_kilobytes
      DbBlaster.configuration.max_message_size_in_kilobytes ||
        DbBlaster.configuration.class::DEFAULT_MAX_MESSAGE_SIZE_IN_KILOBYTES
    end

    def breakup_records
      records.each(&method(:process_record))
      block_on_chunk.call(current_chunk) if current_chunk.length.positive?
    end

    private

    def process_record(record)
      record_size = record.to_json.size
      @current_chunk_size += record_size
      if current_chunk_size < max_bytes
        current_chunk << record
      elsif record_size >= max_bytes
        blow_up_one_record_too_large(record)
      else
        yield_chunk(record, record_size)
      end
    end

    def yield_chunk(record, record_size)
      block_on_chunk.call(current_chunk)
      @current_chunk_size = record_size
      @current_chunk = [record]
    end

    def blow_up_one_record_too_large(record)
      block_on_chunk.call(current_chunk) if current_chunk.length.positive?
      raise OneRecordTooLargeError.new(source_table: source_table,
                                       record: record,
                                       max_kilobytes: max_kilobytes)
    end
  end
end
