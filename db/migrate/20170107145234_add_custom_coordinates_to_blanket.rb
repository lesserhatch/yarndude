class AddCustomCoordinatesToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :custom_coordinates, :boolean
  end
end
