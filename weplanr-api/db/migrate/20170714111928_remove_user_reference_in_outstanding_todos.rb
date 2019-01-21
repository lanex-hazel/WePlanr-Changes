class RemoveUserReferenceInOutstandingTodos < ActiveRecord::Migration[5.0]
  def change
    remove_column :outstanding_todos, :user_id
  end
end
