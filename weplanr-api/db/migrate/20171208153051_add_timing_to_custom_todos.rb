class AddTimingToCustomTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_todos, :timing_min_month, :integer
    add_column :custom_todos, :timing_max_month, :integer
  end
end
