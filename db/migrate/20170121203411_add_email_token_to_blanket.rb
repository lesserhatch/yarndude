class AddEmailTokenToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :email_token, :string, limit: 16
  end
end
