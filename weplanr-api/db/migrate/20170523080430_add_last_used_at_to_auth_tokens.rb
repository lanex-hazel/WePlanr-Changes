class AddLastUsedAtToAuthTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :auth_tokens, :last_used_at, :datetime
  end
end
