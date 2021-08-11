# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::FinderSql do
  subject(:finder_sql) { described_class.new(source_table) }

  let!(:source_table) do
    create(:db_blaster_source_table, name: name,
                                     batch_size: batch_size,
                                     ignored_columns: ['ignored_columns'],
                                     last_published_updated_at: last_published_updated_at)
  end
  let(:batch_size) { 10 }
  let(:name) { 'mountains' }
  let(:last_published_updated_at) { nil }

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
        where = "WHERE updated_at >= '#{source_table.reload.last_published_updated_at.to_s(:db)}'"
        limit = "LIMIT #{source_table.batch_size}"
        "SELECT * FROM #{source_table.name} #{where} ORDER BY updated_at ASC #{limit}"
      end

      its(:select_sql) { is_expected.to eq(expected_sql) }
    end
  end
end
