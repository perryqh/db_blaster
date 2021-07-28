# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::PublishSourceTable do
  let(:source_table) { create(:db_blaster_source_table, name: 'mountains') }
  let(:mountains) do
    ActiveRecord::Base.connection.execute('SELECT * FROM mountains ORDER BY updated_at').collect(&:to_h)
  end

  before do
    create_mountain
  end

  describe '#execute' do
    subject(:execute) { described_class.execute(source_table) }

    before do
      allow(DbBlaster::Publisher).to receive(:publish)
    end

    its(:source_table) { is_expected.to eq(source_table) }

    it 'updates the source-table last_published_at' do
      expect { execute }.to change { source_table.reload.last_published_updated_at }
        .to(mountains.last['updated_at'])
    end

    it 'publishes records' do
      execute
      expect(DbBlaster::Publisher).to have_received(:publish) do |in_source_table, records|
        expect(in_source_table).to eq(source_table)
        expect(records.length).to eq(1)
        expect(records.first['id']).to eq(mountains.first['id'])
      end
    end
  end
end
