class AddAddressToBlankets < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :address, :string
  end
end
