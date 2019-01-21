class AddAuthCodeToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :stripe_auth_code, :string
  end
end
