class AddColumnsToBudget < ActiveRecord::Migration[5.0]
  def change
    add_column :budgets, :actual, :integer, default: 0
    add_column :budgets, :paid, :integer, default: 0
  end
end
