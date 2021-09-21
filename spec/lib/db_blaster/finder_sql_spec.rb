# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::FinderSql do
  subject(:finder_sql) { described_class.new(source_table) }

  let!(:source_table) do
    create(:db_blaster_source_table, name: name,
                                     batch_size: batch_size,
                                     ignored_columns: ['ignored_columns'],
                                     last_published_updated_at: last_published_updated_at,
                                     last_published_id: last_published_id)
  end
  let(:batch_size) { 10 }
  let(:name) { 'mountains' }
  let(:last_published_updated_at) { nil }
  let(:last_published_id) { '3' }

  describe '#select_sql' do
    context 'when last_published_updated_at not set' do
      let(:expected_sql) do
        "SELECT * FROM #{source_table.name}  ORDER BY updated_at ASC LIMIT #{source_table.batch_size}"
      end

      its(:select_sql) { is_expected.to eq(expected_sql) }
    end

    context 'when last_published_updated_at set' do
      let(:last_published_updated_at) { Time.zone.now }
      let(:expected_sql) do
        last_updated = source_table.reload.last_published_updated_at.strftime('%Y-%m-%d %H:%M:%S.%6N')
        where = "WHERE updated_at > '#{last_updated}'"
        where += " OR (updated_at = '#{last_updated}' AND id <> '#{source_table.reload.last_published_id}')"
        limit = "LIMIT #{source_table.batch_size}"
        "SELECT * FROM #{source_table.name} #{where} ORDER BY updated_at ASC #{limit}"
      end

      its(:select_sql) { is_expected.to eq(expected_sql) }
    end
  end
end
