class RemoveOverdueFromTodos < ActiveRecord::Migration[5.0]
  def change
    remove_column :todos, :overdue, :json, default: {}
  end
end
