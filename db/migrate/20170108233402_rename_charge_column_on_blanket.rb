class RenameChargeColumnOnBlanket < ActiveRecord::Migration[5.0]
  def change
    rename_column :blankets, :charge, :charge_id
  end
end
