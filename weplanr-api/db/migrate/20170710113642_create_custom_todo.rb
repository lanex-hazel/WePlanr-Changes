class CreateCustomTodo < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_todos do |t|
      t.references :wedding, index: true
      t.string :name
      t.string :status, default: 'pending'
    end
  end
end
