class AddLargeToMountain < ActiveRecord::Migration[6.1]
  def change
    add_column :mountains, :verbose_description, :text
  end
end
