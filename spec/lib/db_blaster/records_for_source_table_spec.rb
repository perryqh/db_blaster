# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::RecordsForSourceTable do
  subject(:records) do
    result = []
    described_class.find(source_table) do |records|
      result += records.as_json
    end
    result
  end

  let!(:source_table) do
    create(:db_blaster_source_table, name: name,
                                     batch_size: batch_size,
                                     ignored_columns: ['ignored_columns'],
                                     last_published_updated_at: last_published_updated_at)
  end
  let(:batch_size) { 10 }
  let(:name) { 'db_blaster_source_tables' }
  let(:last_published_updated_at) { nil }

  it do
    expect(records).to eq([{ created_at: source_table.created_at.utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
                             id: source_table.id,
                             name: source_table.name,
                             last_published_updated_at: nil,
                             batch_size: batch_size,
                             updated_at: source_table.updated_at.utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ') }
                             .stringify_keys])
  end

  context 'when last_published_updated_at is set' do
    let(:last_published_updated_at) { Time.zone.now }
    let(:name) { 'mountains' }

    before do
      create_mountain
    end

    it { is_expected.to be_empty }
  end

  context 'when more elements than batch_size' do
    let(:batch_size) { 10 }
    let(:name) { 'mountains' }
    let(:updated_at) { nil }

    before do
      ['Hood', 'Gannet', 'Teton', 'Cirque', 'Rocky',
       'Smokey', 'Medicine Bowl', 'Cloud', 'Francs', 'Fremont', 'Jackson', 'Turret'].each do |name|
        create_mountain(name: name, updated_at: updated_at)
      end
    end

    its(:length) { is_expected.to eq(12) }

    context 'when updated_ats are the same' do
      let(:updated_at) { Time.zone.now }

      its(:length) { is_expected.to eq(12) }
    end
  end

  context 'when source_table.name is not a table in the db' do
    let(:name) { 'notganotganotgoingtoworkhereanymore' }

    it 'raises error' do
      expect { records }.to raise_error("source_table.name: '#{name}' does not exist!")
    end
  end
end
