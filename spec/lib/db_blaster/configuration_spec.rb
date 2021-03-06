# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::Configuration do
  describe '#verfiy!' do
    subject(:configuration) { described_class.new }

    context 'when required attributes are not set' do
      let(:expected_error) do
        'missing configuration values for [aws_access_key, aws_access_secret, aws_region]'
      end

      before do
        configuration.sns_topic = ''
        configuration.aws_access_key = nil
        configuration.aws_access_secret = nil
        configuration.aws_region = ' '
      end

      it 'raises informative error' do
        expect do
          configuration.verify!
        end.to raise_error(expected_error)
      end
    end

    context 'when none of the either ors are set' do
      let(:expected_error) do
        'only one of [sns_topic, s3_bucket] should be set'
      end

      before do
        configuration.aws_access_key = 'key'
        configuration.aws_access_secret = 'secret'
        configuration.aws_region = 'us-west-1'
      end

      it 'raises informative error' do
        expect do
          configuration.verify!
        end.to raise_error(expected_error)
      end
    end

    context 'when all required values are set' do
      subject(:configuration) { DbBlaster.configuration }

      before do
        DbBlaster.configure do |config|
          config.sns_topic = 'my topic'
        end
      end

      it 'does not raise error' do
        expect { configuration.verify! }.to_not raise_error
      end

      its(:sns_topic) { is_expected.to eq('my topic') }
      its(:aws_access_key) { is_expected.to eq('aws key') }
      its(:aws_access_secret) { is_expected.to eq('shhhh') }
      its(:aws_region) { is_expected.to eq('us-west-1') }
    end
  end
end
