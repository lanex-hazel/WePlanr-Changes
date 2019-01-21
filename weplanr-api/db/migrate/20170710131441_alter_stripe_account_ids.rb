class AlterStripeAccountIds < ActiveRecord::Migration[5.0]
  def change
    rename_column :vendors, :stripe_auth_code, :stripe_account_id
    rename_column :weddings, :stripe_id, :stripe_account_id
  end
end
