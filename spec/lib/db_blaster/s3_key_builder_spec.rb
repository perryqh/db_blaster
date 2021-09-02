# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::S3KeyBuilder do
  let(:source_table_name) { 'mountains' }
  let(:batch_start_time) { 5.minutes.ago.utc.strftime(DbBlaster::Configuration::DEFAULT_DATETIME_FORMAT) }
  let!(:now) { DateTime.now }
  let!(:uuid) { SecureRandom.uuid }
  let(:batch_date) { batch_start_time.split('T').first }
  let(:batch_time) { batch_start_time.split('T').last }

  before do
    allow(DateTime).to receive(:now).and_return(now)
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  describe '.build' do
    subject(:build) { described_class.build(source_table_name: source_table_name, batch_start_time: batch_start_time) }

    context 'with default key' do
      it { is_expected.to eq("#{batch_date}/#{batch_time}/db_blaster/#{source_table_name}/#{uuid}.json") }
    end

    context 'with custom default key' do
      before do
        DbBlaster.configure do |config|
          config.s3_key = '<batch_date_time>/kcp-api/<table_name>/<uuid>.json'
        end
      end

      it { is_expected.to eq("#{batch_start_time}/kcp-api/#{source_table_name}/#{uuid}.json") }
    end

    context 'with date_time' do
      before do
        DbBlaster.configure do |config|
          config.s3_key = '<batch_date_time>/kcp-api/<table_name>/<date_time>.json'
        end
      end

      let(:date_time) { now.utc.strftime(DbBlaster::Configuration::DEFAULT_DATETIME_FORMAT) }

      it { is_expected.to eq("#{batch_start_time}/kcp-api/#{source_table_name}/#{date_time}.json") }
    end

    context 'with date and time key' do
      before do
        DbBlaster.configure do |config|
          config.s3_key = '<batch_date>/<batch_time>/kcp-api/<table_name>/<uuid>.json'
        end
      end

      it { is_expected.to eq("#{batch_date}/#{batch_time}/kcp-api/#{source_table_name}/#{uuid}.json") }
    end
  end
end
