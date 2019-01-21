class RenameExpiredAtToExpiresAt < ActiveRecord::Migration[5.0]
  def change
    rename_column :quotes, :expired_at, :expires_at
  end
end
