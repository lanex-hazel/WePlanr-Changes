class RemoveRelevantServiceIdsFromTodos < ActiveRecord::Migration[5.0]
  def change
    remove_column :todos, :relevant_service_ids, :integer, array: true
  end
end
