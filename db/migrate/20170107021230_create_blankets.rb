class CreateBlankets < ActiveRecord::Migration[5.0]
  def change
    create_table :blankets do |t|
      t.string :name
      t.string :email
      t.date :start_date
      t.date :end_date
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end
  end
end
