# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::SourceTableConfigurationBuilder do
  subject(:builder) { described_class.new(configuration) }

  let!(:configuration) do
    config = DbBlaster::Configuration.new
    config.sns_topic = 'my topic'
    config.aws_access_key = 'aws key'
    config.aws_access_secret = 'shhhh'
    config.aws_region = 'us-west-1'
    config.only_source_tables = only_source_tables
    config.ignored_column_names = ignored_column_names
    config.source_table_options = source_table_options
    config.batch_size = batch_size
    config
  end
  let(:only_source_tables) { %w[mountains] }
  let(:source_table_options) { nil }
  let(:ignored_column_names) { nil }
  let(:batch_size) { nil }

  its(:available_tables) { is_expected.to match_array(%w[db_blaster_source_tables trails mountains]) }
  its(:table_names_for_configuration) { is_expected.to eq(['mountains']) }

  it 'builds source_table_configuration' do
    expect(builder.build_all.collect(&:source_table_name)).to eq(['mountains'])
  end

  it 'builds update_params' do
    expect(builder.build_all.first.update_params).to eq(batch_size: configuration.default_batch_size,
                                                        ignored_columns: [])
  end

  context 'when batch_size' do
    let(:batch_size) { 5 }

    it 'builds source_table_configuration' do
      expect(builder.build_all.collect(&:source_table_name)).to eq(['mountains'])
    end

    it 'builds update_params' do
      expect(builder.build_all.first.update_params).to eq(batch_size: 5, ignored_columns: [])
    end
  end

  context 'when ignored_column_names' do
    let(:ignored_column_names) { ['email'] }

    it 'builds source_table_configuration' do
      expect(builder.build_all.collect(&:source_table_name)).to eq(['mountains'])
    end

    it 'sets the configuration update_params' do
      expect(builder.build_all.first.update_params).to eq(ignored_columns: ['email'],
                                                          batch_size: configuration.default_batch_size)
    end
  end

  context 'when no only_source_tables' do
    let(:only_source_tables) { nil }

    its(:table_names_for_configuration) { is_expected.to match_array(%w[mountains trails db_blaster_source_tables]) }

    it 'builds source_table_configuration' do
      expect(builder.build_all.collect(&:source_table_name)).to match_array(%w[mountains trails
                                                                               db_blaster_source_tables])
    end

    context 'with ignored_column_names' do
      let(:ignored_column_names) { ['phone_number'] }

      it 'builds source_table_configuration' do
        all_match = builder.build_all.collect(&:update_params)
                           .all? do |config|
          config == { ignored_columns: ['phone_number'], batch_size: configuration.default_batch_size }
        end
        expect(all_match).to be_truthy
      end
    end
  end

  context 'with source_table_options' do
    let(:only_source_tables) { %w[mountains trails] }
    let(:trail_configuration) do
      builder.build_all.detect { |config| config.source_table_name == 'trails' }
    end
    let(:mountain_configuration) do
      builder.build_all.detect { |config| config.source_table_name == 'mountains' }
    end
    let(:batch_size) { 75 }
    let(:ignored_column_names) { ['name'] }
    let(:source_table_options) do
      [{ source_table_name: 'trails', ignored_column_names: ['phone_number'], batch_size: 50 }]
    end

    it 'properly overrides options' do
      expect(trail_configuration.update_params).to eq(ignored_columns: ['phone_number'], batch_size: 50)
    end

    it 'uses global configurations when no overrides present' do
      expect(mountain_configuration.update_params).to eq(ignored_columns: ['name'], batch_size: 75)
    end
  end
end
