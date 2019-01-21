class AlterTodos < ActiveRecord::Migration[5.0]
  def change
    remove_column :todos, :task, :string
    remove_column :todos, :status, :string
    remove_column :todos, :done_at, :string
    remove_reference :todos, :wedding, index: true, foreign_key: true

    add_column :todos, :name, :string
    add_column :todos, :search_terms, :string
    add_column :todos, :relevent_vendor_ids, :string
    add_column :todos, :timing, :string
    add_column :todos, :overdue, :json, default: {}
    add_column :todos, :suggestion_copy, :json, default: {}
    add_column :todos, :reminder_copy, :string
    add_column :todos, :question_copy, :string
    add_column :todos, :redirect_copy, :string
  end
end
