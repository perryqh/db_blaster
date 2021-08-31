# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbBlaster::Publisher do
  subject(:publisher) { described_class.new(source_table, records) }

  let(:source_table) { create(:db_blaster_source_table, name: 'mountains') }
  let(:records) do
    [{ 'id' => 3, 'name' => 'foo' }]
  end

  it 'raises error on abstract publish' do
    expect { publisher.publish }.to raise_error(NotImplementedError)
  end

  describe '.publish' do
    let(:sns_publisher) { instance_double(DbBlaster::SnsPublisher) }
  end
end
