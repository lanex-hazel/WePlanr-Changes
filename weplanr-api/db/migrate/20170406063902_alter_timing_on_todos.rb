class AlterTimingOnTodos < ActiveRecord::Migration[5.0]
  def change
    remove_column :todos, :timing, :string
    add_column :todos, :timing_min_month, :integer
    add_column :todos, :timing_max_month, :integer
  end
end
