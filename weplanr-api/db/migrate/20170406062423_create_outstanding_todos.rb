class CreateOutstandingTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :outstanding_todos do |t|
      t.integer :views, default: 0
      t.references :user, index: true
      t.references :todo, index: true
    end
  end
end
