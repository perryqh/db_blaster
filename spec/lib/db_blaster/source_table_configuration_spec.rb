# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::SourceTableConfiguration do
  subject(:configuration) do
    described_class.new(source_table_name: source_table_name,
                        batch_size: batch_size,
                        ignored_column_names: ignored_column_names)
  end

  let(:source_table_name) { 'mountains' }
  let(:batch_size) { 10 }
  let(:ignored_column_names) { ['email'] }

  its(:update_params) do
    is_expected.to eq(batch_size: batch_size,
                      ignored_columns: ignored_column_names)
  end

  its(:source_table_name) { source_table_name }
  its(:batch_size) { batch_size }
  its(:ignored_column_names) { [ignored_column_names] }
end
