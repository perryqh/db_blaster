# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::Configuration do
  describe '#verfiy!' do
    subject(:configuration) { described_class.new }

    context 'when required attributes are not set' do
      before do
        configuration.sns_topic = ''
        configuration.aws_access_key = nil
        configuration.aws_access_secret = nil
        configuration.aws_region = ' '
      end

      it 'raises informative error' do
        expect do
          configuration.verify!
        end.to raise_error('missing configuration values for [aws_access_key, aws_access_secret, aws_region, sns_topic]')
      end
    end

    context 'when all required values are set' do
      it 'does not raise error' do
        DbBlaster.configuration.verify!
        expect(DbBlaster.configuration.sns_topic).to eq('my topic')
        expect(DbBlaster.configuration.aws_access_key).to eq('aws key')
        expect(DbBlaster.configuration.aws_access_secret).to eq('shhhh')
        expect(DbBlaster.configuration.aws_region).to eq('us-west-1')
      end
    end
  end
end
