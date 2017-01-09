class AddChargeToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :charge, :string
  end
end
