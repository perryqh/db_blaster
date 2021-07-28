# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::PublishAllJob, type: :job do
  include ActiveJob::TestHelper

  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  describe '#perform' do
    let!(:existing_source_table) { create(:db_blaster_source_table, name: 'mountains') }

    before do
      allow(DbBlaster::SourceTable).to receive(:sync)
      create_mountain
      DbBlaster.configure do |config|
        config.source_tables = [{ name: 'taco-bar' }]
      end
    end

    it 'enqueues PublishSourceTableJob' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.new.perform
      end.to have_enqueued_job.with(existing_source_table.id).on_queue('default')
    end

    it 'syncs source table' do
      described_class.new.perform
      expect(DbBlaster::SourceTable).to have_received(:sync).with(DbBlaster.configuration.source_tables)
    end
  end
end
