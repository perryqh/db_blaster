class CreateSourceTables < ActiveRecord::Migration[6.1]
  def change
    create_table :db_blaster_source_tables do |t|
      t.string :name, null: false
      t.text :ignored_columns, array: true, default: []
      t.datetime :last_published_updated_at # the most recent published `updated_at`
      t.integer :batch_size, default: 100
      t.timestamps
    end
  end
end
