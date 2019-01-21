class AddLastActivityAtToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :last_activity_at, :datetime
  end
end
