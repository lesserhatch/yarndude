class AddSlugToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :slug, :string
    add_index :blankets, :slug, :unique => true
  end
end
