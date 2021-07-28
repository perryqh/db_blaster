# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::Publisher do
  let(:source_table) { create(:db_blaster_source_table, name: 'mountains') }
  let(:records) do
    [{ 'id' => 3, 'name' => 'foo' }]
  end
  let(:client) { instance_double(Aws::SNS::Client) }
  let(:resource) { instance_double(Aws::SNS::Resource) }
  let(:credentials) { instance_double(Aws::Credentials) }
  let(:topic) { instance_double(Aws::SNS::Topic) }

  before do
    allow(Aws::SNS::Client).to receive(:new).and_return(client)
    allow(Aws::SNS::Resource).to receive(:new).and_return(resource)
    allow(resource).to receive(:topic).and_return(topic)
    allow(topic).to receive(:publish)
    allow(Aws::Credentials).to receive(:new).and_return(credentials)
  end

  describe '#publish' do
    subject(:publish) { described_class.publish(source_table, records) }

    it 'instantiates credentials' do
      publish
      expect(Aws::Credentials).to have_received(:new).with(DbBlaster.configuration.aws_access_key,
                                                           DbBlaster.configuration.aws_access_secret)
    end

    it 'instantiates client' do
      publish
      expect(Aws::SNS::Client).to have_received(:new).with(region: DbBlaster.configuration.aws_region,
                                                           credentials: credentials)
    end

    it 'references the topic' do
      publish
      expect(resource).to have_received(:topic).with(DbBlaster.configuration.sns_topic)
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'publishes' do
      publish
      expect(topic).to have_received(:publish) do |args|
        expect(args[:message]).to eq(records.to_json)
        expect(args[:message_attributes]).to eq('source_table' =>
                                                  { data_type: 'String', string_value: source_table.name })
      end
    end
    # rubocop:enable RSpec/MultipleExpectations

    context 'with extra_sns_message_attributes' do
      before do
        DbBlaster.configure do |config|
          config.extra_sns_message_attributes = { 'infra_id' => { data_type: 'String', string_value: '061' } }
        end
      end

      after do
        DbBlaster.configure do |config|
          config.extra_sns_message_attributes = {}
        end
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'publishes with extra attributes' do
        publish
        expect(topic).to have_received(:publish) do |args|
          expect(args).to eq(message: records.to_json,
                             message_attributes: { 'source_table' =>
                                                     { data_type: 'String', string_value: source_table.name },
                                                   'infra_id' => { data_type: 'String', string_value: '061' } })
        end
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
