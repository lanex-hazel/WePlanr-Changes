class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.string :users_uid, array: true, default: []
      t.string :vendor_uid
      t.timestamps
    end
  end
end
