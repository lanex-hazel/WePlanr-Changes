class ChangeReferenceToServices < ActiveRecord::Migration[5.0]
  def change
    remove_reference :todos, :category, index: true
    remove_reference :custom_todos, :category, index: true
    add_reference :todos, :service, index: true
    add_reference :custom_todos, :service, index: true
  end
end
