class DropTodoCategories < ActiveRecord::Migration[5.0]
  def change
    drop_table :todo_categories
  end
end
