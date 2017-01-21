class AddEmailConfirmedToBlanket < ActiveRecord::Migration[5.0]
  def change
    add_column :blankets, :email_confirmed, :boolean, default: false
  end
end
