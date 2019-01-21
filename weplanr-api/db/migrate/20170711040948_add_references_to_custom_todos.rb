class AddReferencesToCustomTodos < ActiveRecord::Migration[5.0]
  def change
    add_reference :custom_todos, :booking, index: true
    add_reference :custom_todos, :outside_vendor, index: true
  end
end
