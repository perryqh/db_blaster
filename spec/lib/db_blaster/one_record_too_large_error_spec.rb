# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::OneRecordTooLargeError do
  subject(:error) do
    described_class.new(source_table: source_table,
                        record: record,
                        max_kilobytes: max_kilobytes)
  end

  let(:source_table) { create(:db_blaster_source_table) }
  let(:record) { { foo: 'bar' } }
  let(:max_kilobytes) { 256 }
  let(:expected_message) do
    ["One individual record with ID '#{record[:id]}'",
     " in source-table '#{source_table.name}'",
     " is larger than #{max_kilobytes} KB!"].join(' ')
  end

  its(:message) do
    is_expected.to eq(expected_message)
  end
end
