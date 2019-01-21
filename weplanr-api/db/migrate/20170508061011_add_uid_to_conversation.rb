class AddUidToConversation < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :uid, :string, index: true
  end
end
