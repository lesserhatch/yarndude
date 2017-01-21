class AddPrivateAttributeToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :private, :boolean, default: false
  end
end
