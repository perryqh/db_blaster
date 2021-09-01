# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::S3Publisher do
  let(:source_table) { create(:db_blaster_source_table, name: 'mountains') }
  let(:records) do
    [{ 'id' => 3, 'name' => 'foo' }]
  end
  let(:client) { instance_double(Aws::S3::Client) }
  let(:credentials) { instance_double(Aws::Credentials) }
  let(:s3_bucket) { 'a-bucket' }
  let(:batch_start_time) { DateTime.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ') }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return(client)
    allow(client).to receive(:put_object)
    allow(Aws::Credentials).to receive(:new).and_return(credentials)
    DbBlaster.configure do |config|
      config.s3_bucket = s3_bucket
      config.sns_topic = nil
    end
  end

  describe '#publish' do
    subject(:publish) do
      described_class.publish(source_table: source_table, records: records, batch_start_time: batch_start_time)
    end

    let(:key) { 'the/key/file.json' }
    let(:expected_body) do
      { meta: { source_table: source_table.name },
        records: records }.to_json
    end
    let(:expected_tagging) do
      'source_table=mountains'
    end

    before do
      allow(DbBlaster::S3KeyBuilder).to receive(:build).and_return(key)
    end

    it 'instantiates credentials' do
      publish
      expect(Aws::Credentials).to have_received(:new).with(DbBlaster.configuration.aws_access_key,
                                                           DbBlaster.configuration.aws_access_secret)
    end

    it 'instantiates client' do
      publish
      expect(Aws::S3::Client).to have_received(:new).with(region: DbBlaster.configuration.aws_region,
                                                          credentials: credentials)
    end

    it 'delegates to S3KeyBuilder for key' do
      publish
      expect(DbBlaster::S3KeyBuilder).to have_received(:build)
        .with(source_table_name: source_table.name,
              batch_start_time: batch_start_time,
              tagging: expected_tagging)
    end

    it 'publishes' do
      publish
      expect(client).to have_received(:put_object)
        .with(bucket: s3_bucket,
              key: key,
              body: expected_body)
    end

    context 'with s3_meta and tags' do
      before do
        DbBlaster.configure do |config|
          config.s3_meta = { 'infra_id' => '061' }
          config.s3_tags = { source_app: 'kcp-api', foo: 'value with space' }
        end
      end

      let(:expected_body) do
        { meta: { infra_id: '061', source_table: source_table.name },
          records: records }.to_json
      end
      let(:expected_tagging) do
        'foo=value with space&source_app=kcp-api&source_table=meetings'
      end

      it 'publishes meta' do
        publish
        expect(client).to have_received(:put_object)
          .with(bucket: s3_bucket,
                key: key,
                body: expected_body,
                tagging: expected_tagging)
      end
    end
  end
end
