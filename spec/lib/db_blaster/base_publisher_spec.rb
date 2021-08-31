# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::BasePublisher do
  subject(:publisher) { described_class.new(source_table, records) }

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
        described_class.publish(source_table, records)
        expect(DbBlaster::SnsPublisher).to have_received(:new).with(source_table, records)
      end
    end

    context 'when s3_bucket set' do
      before do
        DbBlaster.configure do |config|
          config.sns_topic = nil
          config.s3_bucket = 'mybucket'
        end

        it 'delegates to s3-publisher' do
          described_class.publish(source_table, records)
          expect(DbBlaster::S3Publisher).to have_received(:new).with(source_table, records)
        end
      end
    end
  end
end