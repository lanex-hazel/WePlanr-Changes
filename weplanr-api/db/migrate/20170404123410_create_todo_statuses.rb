class CreateTodoStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_statuses do |t|
      t.integer :wedding_id
      t.integer :todo_id
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
