# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::SourceTable do
  describe 'name validations' do
    subject(:source_table) { build(:db_blaster_source_table, name: name) }

    let(:name) { 'mountains' }
    its(:batch_size) { is_expected.to eq(100) }

    context 'when name is blank' do
      let(:name) { '' }

      it 'is invalid' do
        expect(source_table.valid?).to be_falsey
        expect(source_table.errors[:name]).to eq(["can't be blank"])
      end
    end

    describe '#sync' do
      let(:configs) do
        [{ name: 'restaurants', batch_size: 100, ignored_columns: [:customers] },
         { name: 'parks', batch_size: 20, ignored_columns: [:toys] }]
      end
      let!(:source_table) { create(:db_blaster_source_table, name: 'cities') }

      it 'syncs by provided configs' do
        expect { described_class.sync(configs) }.to change {
          described_class.all.pluck(:name).sort
        }.to(%w[parks restaurants])
        expect(described_class.all.pluck(:batch_size)).to match_array([20, 100])
        expect(described_class.all.pluck(:ignored_columns)).to match_array([['customers'], ['toys']])
      end
    end

    context 'when name is not unique' do
      let(:name) { 'meetings' }
      let!(:pre_existing_source_table) { create(:db_blaster_source_table, name: 'Meetings') }

      it 'is invalid' do
        expect(source_table.valid?).to be_falsey
        expect(source_table.errors[:name]).to eq(['has already been taken'])
      end
    end
  end
end
