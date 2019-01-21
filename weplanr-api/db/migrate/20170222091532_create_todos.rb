class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :task
      t.string :status
      t.references :user, foreign_key: true
      t.datetime :done_at
    end
  end
end
