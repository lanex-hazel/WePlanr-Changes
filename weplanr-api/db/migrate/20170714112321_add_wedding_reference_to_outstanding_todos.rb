class AddWeddingReferenceToOutstandingTodos < ActiveRecord::Migration[5.0]
  def change
    add_reference :outstanding_todos, :wedding, index: true
  end
end
