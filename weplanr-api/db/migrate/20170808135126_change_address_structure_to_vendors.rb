class ChangeAddressStructureToVendors < ActiveRecord::Migration[5.0]
  def change
    rename_column :vendors, :street_address, :registered_street_address
    rename_column :vendors, :country, :registered_country
    rename_column :vendors, :post_code, :registered_post_code
    add_column :vendors, :registered_suburb, :string
    add_column :vendors, :registered_state, :string
  end
end
