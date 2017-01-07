class AddTimezoneToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :timezone, :string
  end
end
