class AddCategoryIdToTodos < ActiveRecord::Migration[5.0]
  def change
    add_reference :todos, :todo_category, index: true
    add_reference :custom_todos, :todo_category, index: true
  end
end
