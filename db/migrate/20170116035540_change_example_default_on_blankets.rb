class ChangeExampleDefaultOnBlankets < ActiveRecord::Migration[5.0]
  def change
    change_column_default :blankets, :example, false
  end
end
