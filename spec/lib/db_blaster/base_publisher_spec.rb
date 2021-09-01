# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::BasePublisher do
  subject(:publisher) { described_class.new(source_table, records, batch_start_time) }

  let(:batch_start_time) { DateTime.now.utc.to_s }
  let(:source_table) { create(:db_blaster_source_table, name: 'mountains') }
  let(:records) do
    [{ 'id' => 3, 'name' => 'foo' }]
  end

  it 'raises error on abstract publish' do
    expect { publisher.publish }.to raise_error(NotImplementedError)
  end

  describe '.publish' do
    let(:sns_publisher) { instance_double(DbBlaster::SnsPublisher, publish: nil) }
    let(:s3_publisher) { instance_double(DbBlaster::S3Publisher, publish: nil) }

    before do
      allow(DbBlaster::SnsPublisher).to receive(:new).and_return(sns_publisher)
      allow(DbBlaster::S3Publisher).to receive(:new).and_return(sns_publisher)
    end

    context 'when sns_topic set' do
      before do
        DbBlaster.configure do |config|
          config.sns_topic = 'topic'
          config.s3_bucket = nil
        end
      end

      it 'delegates to sns-publisher' do
        described_class.publish(source_table: source_table, records: records, batch_start_time: batch_start_time)
        expect(DbBlaster::SnsPublisher).to have_received(:new).with(source_table, records, batch_start_time)
      end
    end

    context 'when s3_bucket set' do
      before do
        DbBlaster.configure do |config|
          config.sns_topic = nil
          config.s3_bucket = 'mybucket'
        end
      end

      it 'delegates to s3-publisher' do
        described_class.publish(source_table: source_table, records: records, batch_start_time: batch_start_time)
        expect(DbBlaster::S3Publisher).to have_received(:new).with(source_table, records, batch_start_time)
      end
    end
  end
end
