# frozen_string_literal: true

# Adding last_published_id to avoid dupes in selecting sourcetables
class AddLastPublishedId < ActiveRecord::Migration[6.1]
  def change
    add_column :db_blaster_source_tables, :last_published_id, :string, default: '0'
  end
end
