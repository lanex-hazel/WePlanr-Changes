class CreateTodoCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_categories do |t|
      t.string :name
    end
  end
end
