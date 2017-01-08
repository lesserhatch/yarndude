class AddReadyFlagToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :ready, :boolean
  end
end
