class AddUtcOffsetToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :utc_offset, :integer
  end
end
