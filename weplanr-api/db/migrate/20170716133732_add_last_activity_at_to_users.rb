class AddLastActivityAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_activity_at, :datetime
  end
end
