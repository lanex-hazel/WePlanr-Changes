class AddTodoIdToBudgets < ActiveRecord::Migration[5.0]
  def change
    add_reference :budgets, :todo, index: true
  end
end
