class CreateYarns < ActiveRecord::Migration[5.0]
  def change
    create_table :yarns do |t|
      t.string :name

      t.timestamps
    end
  end
end
