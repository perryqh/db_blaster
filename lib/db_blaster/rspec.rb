# frozen_string_literal: true

if defined?(FactoryBot)
  FactoryBot.define do
    factory :db_blaster_source_table, class: DbBlaster::SourceTable do
      sequence(:name) { |n| "table_#{n}" }
    end
  end
end
