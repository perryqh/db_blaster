class CreateTrails < ActiveRecord::Migration[6.1]
  def change
    create_table :trails do |t|
      t.string :name
      t.integer :distance
      t.string :phone_number
      t.timestamps
    end
  end
end
