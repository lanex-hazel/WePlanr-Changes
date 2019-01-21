class CreateTodoNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_notes do |t|
      t.belongs_to :wedding, index: true
      t.references :noteable, polymorphic: true
      t.text :content

      t.timestamps
    end
  end
end
