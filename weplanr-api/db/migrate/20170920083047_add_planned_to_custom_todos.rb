class AddPlannedToCustomTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_todos, :planned, :integer, default: 0
  end
end
