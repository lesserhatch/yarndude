class AddCustomerToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :customer_id, :string
  end
end
