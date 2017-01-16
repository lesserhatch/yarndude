class AddExampleToBlankets < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :example, :boolean
  end
end
