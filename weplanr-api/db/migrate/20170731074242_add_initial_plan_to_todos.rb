class AddInitialPlanToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :is_initial_plan, :boolean
  end
end
