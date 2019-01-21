class AddBudgetPercentToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :budget_percent, :decimal
  end
end
