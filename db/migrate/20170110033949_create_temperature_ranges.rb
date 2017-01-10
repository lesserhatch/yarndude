class CreateTemperatureRanges < ActiveRecord::Migration[5.0]
  def change
    create_table :temperature_ranges do |t|
      t.references :palette, foreign_key: true
      t.references :yarn, foreign_key: true
      t.integer :low_temperature
      t.integer :high_temperature

      t.timestamps
    end
  end
end
