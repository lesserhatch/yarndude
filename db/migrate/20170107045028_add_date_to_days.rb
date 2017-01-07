class AddDateToDays < ActiveRecord::Migration[5.0]
  def change
    add_column :days, :date, :date
  end
end
