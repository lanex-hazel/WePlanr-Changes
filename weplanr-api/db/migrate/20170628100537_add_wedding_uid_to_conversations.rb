class AddWeddingUidToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :wedding_uid, :string, index: true
  end
end
