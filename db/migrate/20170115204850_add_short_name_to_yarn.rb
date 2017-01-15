class AddShortNameToYarn < ActiveRecord::Migration[5.0]
  def change
    add_column :yarns, :short_name, :string
  end
end
