class AddServiceNameToCustomTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_todos, :service_name, :string
  end
end
