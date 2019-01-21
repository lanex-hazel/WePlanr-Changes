class AddActionToLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :logs, :action, :string
  end
end
