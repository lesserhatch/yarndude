class AddLimitToBlanketSlug < ActiveRecord::Migration[5.0]
  def change
    change_column :blankets, :slug, :string, limit: 16
  end
end
