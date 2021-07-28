# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::Sync do
  subject(:syncer) { DbBlaster::SourceTable }

  let!(:source_table_to_be_deleted) { build(:db_blaster_source_table) }

  describe '#sync' do
    let(:configs) do
      [DbBlaster::SourceTableConfiguration.new(source_table_name: 'restaurants', batch_size: 100, ignored_column_names: [:customers]),
       DbBlaster::SourceTableConfiguration.new(source_table_name: 'parks', batch_size: 20, ignored_column_names: [:toys])]
    end
    let!(:source_table) { create(:db_blaster_source_table, name: 'cities') }

    it 'syncs by provided configs' do
      expect { syncer.sync(configs) }.to change {
        syncer.all.pluck(:name).sort
      }.to(%w[parks restaurants])
      expect(syncer.all.pluck(:batch_size)).to match_array([20, 100])
      expect(syncer.all.pluck(:ignored_columns)).to match_array([['customers'], ['toys']])
    end
  end
end
