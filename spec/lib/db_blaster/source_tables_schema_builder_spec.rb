# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::SourceTablesSchemaBuilder do
  subject(:build) { described_class.build_schema }

  its(:keys) { is_expected.to match_array(%w[db_blaster_source_tables mountains trails]) }

  it 'contains columns' do
    expect(build['trails']).to match_array([{ limit: 8, name: 'id', type: :integer },
                                            { limit: nil, name: 'name', type: :string },
                                            { limit: 4, name: 'distance', type: :integer },
                                            { limit: nil, name: 'phone_number', type: :string },
                                            { limit: nil, name: 'created_at', type: :datetime },
                                            { limit: nil, name: 'updated_at', type: :datetime }])
  end

  context 'with ignored columns' do
    before do
      DbBlaster.configure do |config|
        config.ignored_column_names = %w[distance phone_number]
        config.source_table_options = [{ source_table_name: 'trails', ignored_column_names: ['name'] }]
      end
    end

    it 'contains columns' do
      expect(build['trails']).to match_array([{ limit: 8, name: 'id', type: :integer },
                                              { limit: nil, name: 'created_at', type: :datetime },
                                              { limit: nil, name: 'updated_at', type: :datetime }])
    end
  end
end
