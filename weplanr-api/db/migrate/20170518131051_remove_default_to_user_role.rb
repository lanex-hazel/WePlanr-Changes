class RemoveDefaultToUserRole < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :role, nil
  end
end
