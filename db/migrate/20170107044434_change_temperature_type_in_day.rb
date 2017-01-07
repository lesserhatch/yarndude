class ChangeTemperatureTypeInDay < ActiveRecord::Migration[5.0]
  def change
    change_column :days, :high_temperature, :integer
    change_column :days, :low_temperature, :integer
  end
end
