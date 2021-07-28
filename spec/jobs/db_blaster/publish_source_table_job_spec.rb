# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::PublishSourceTableJob do
  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  describe '#perform' do
    subject(:perform) { described_class.new.perform(source_table_id) }

    let(:source_table) { create(:db_blaster_source_table) }

    before do
      allow(DbBlaster::PublishSourceTable).to receive(:execute)
    end

    context 'when source_table_id does not exist' do
      let(:source_table_id) { 'no-bueno' }

      it 'does not attempt to execute PublishSourceTable' do
        perform
        expect(DbBlaster::PublishSourceTable).not_to have_received(:execute)
      end
    end

    context 'when source_table_id exists' do
      let(:source_table_id) { source_table.id }

      it 'delegates to PublishSourceTable' do
        perform
        expect(DbBlaster::PublishSourceTable).to have_received(:execute)
          .with(source_table)
      end
    end
  end
end
