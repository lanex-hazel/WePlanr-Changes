class RemoveSearchTermsFromTodos < ActiveRecord::Migration[5.0]
  def change
    remove_column :todos, :search_terms, :string, array: true
  end
end
