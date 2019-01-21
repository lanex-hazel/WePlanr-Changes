class CreateAdminNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_notifications do |t|
      t.string :description
      t.datetime :sent_at
      t.references :user
    end
  end
end
