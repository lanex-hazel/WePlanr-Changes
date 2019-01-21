class AddCategoryIdToTodos2 < ActiveRecord::Migration[5.0]
  def change
    add_reference :todos, :category, index: true
    add_reference :custom_todos, :category, index: true
    remove_reference :todos, :todo_category, index: true
    remove_reference :custom_todos, :todo_category, index: true
  end
end
