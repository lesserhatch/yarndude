class CreateDays < ActiveRecord::Migration[5.0]
  def change
    create_table :days do |t|
      t.references :blanket, foreign_key: true
      t.decimal :high_temperature
      t.decimal :low_temperature

      t.timestamps
    end
  end
end
