class AddPositionToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :position, :integer
  end
end
