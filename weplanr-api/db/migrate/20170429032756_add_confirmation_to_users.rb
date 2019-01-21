class AddConfirmationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_token_sent_at, :datetime
    add_column :users, :is_confirmed, :boolean, default: false
  end
end
