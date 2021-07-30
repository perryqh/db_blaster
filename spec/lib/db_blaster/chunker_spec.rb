# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::Chunker do
  subject(:chunker) do
    described_class.new(source_table, records, &chunk_block)
  end

  let(:source_table) { create(:db_blaster_source_table) }
  let(:records) { [foo: 'bar', baz: 'boom'] }
  let(:max_message_size_in_kilobytes) { 1 }
  let(:yielded_results) { [] }
  let(:chunk_block) do
    proc do |records|
      yielded_results << records
    end
  end

  before do
    allow(DbBlaster.configuration).to receive(:max_message_size_in_kilobytes)
      .and_return(max_message_size_in_kilobytes)
  end

  it 'does not chunk when records are under max_message_size_in_kilobytes' do
    chunker.chunk
    expect(yielded_results).to eq([records])
  end

  context 'with many records' do
    let(:records) do
      (1..100).collect do |num|
        { foo: num, baz: num.to_s }
      end
    end

    it 'chunks up records into pieces smaller pieces' do
      chunker.chunk
      last_elements = yielded_results.collect { |results| [results.first[:foo], results.last[:foo]] }
      expect(last_elements).to eq([[1, 48], [49, 95], [96, 100]])
    end

    it 'yields every record' do
      chunker.chunk
      combined = yielded_results.inject([]) do |array, results|
        array += results
        array
      end
      expect(combined).to eq(records)
    end

    context 'when 1 record is too large on its own' do
      let(:safe_chunk) do
        chunker.chunk
      rescue DbBlaster::OneRecordTooLargeError
        # ignore
      end

      before do
        records[50][:foo] = '*' * 1000
      end

      it 'raises informative error' do
        expect { chunker.chunk }.to raise_error(DbBlaster::OneRecordTooLargeError)
      end

      it 'processes all records leading up to error' do
        safe_chunk
        combined = yielded_results.inject([]) do |array, results|
          array += results
          array
        end
        expect(combined).to eq(records[0..49])
      end
    end
  end
end
