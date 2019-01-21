class RenameViewsToLogs < ActiveRecord::Migration[5.0]
  def change
    rename_table :views, :logs
  end
end
