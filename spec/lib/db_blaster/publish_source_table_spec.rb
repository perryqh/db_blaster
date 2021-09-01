# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::PublishSourceTable do
  let(:source_table) { create(:db_blaster_source_table, name: 'mountains') }
  let(:mountains) do
    ActiveRecord::Base.connection.execute('SELECT * FROM mountains ORDER BY updated_at').collect(&:to_h)
  end
  let(:batch_start_time) { DateTime.now.utc.to_s }

  before do
    create_mountain
  end

  describe '#execute' do
    subject(:execute) { described_class.execute(source_table: source_table, batch_start_time: batch_start_time) }

    before do
      allow(DbBlaster::BasePublisher).to receive(:publish)
    end

    its(:source_table) { is_expected.to eq(source_table) }

    it 'updates the source-table last_published_at' do
      expect { execute }.to change { source_table.reload.last_published_updated_at }
        .to(mountains.last['updated_at'])
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'publishes records' do
      execute
      expect(DbBlaster::BasePublisher).to have_received(:publish) do |args|
        expect(args[:source_table]).to eq(source_table)
        expect(args[:records].length).to eq(1)
        expect(args[:records].first['id']).to eq(mountains.first['id'])
        expect(args[:batch_start_time]).to eq(batch_start_time)
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
