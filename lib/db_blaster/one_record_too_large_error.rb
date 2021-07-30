# frozen_string_literal: true

module DbBlaster
  # Custom error representing a serious error.
  # If one individual record is larger than the max bytes
  # allowed, db_blaster "fails fast".
  # If we ignored this record and moved on, it would never make it
  # to SNS as its `updated_at` would end up being less than the
  # last processed record.
  # Possible fixes:
  # 1) if possible ignore the column(s) that are too large
  # 2) manually move the record to the intended destination
  # 3) bug me to provide an S3 workaround
  class OneRecordTooLargeError < StandardError
    attr_reader :source_table, :record, :max_kilobytes

    def initialize(params)
      super
      params.each_key do |key|
        instance_variable_set("@#{key}", params[key])
      end
    end

    def message
      ["One individual record with ID '#{record[:id]}'",
       " in source-table '#{source_table.name}'",
       " is larger than #{max_kilobytes} KB!"].join(' ')
    end
  end
end
