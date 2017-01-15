class AddColorToYarn < ActiveRecord::Migration[5.0]
  def change
    add_column :yarns, :color, :string, limit: 6
  end
end
