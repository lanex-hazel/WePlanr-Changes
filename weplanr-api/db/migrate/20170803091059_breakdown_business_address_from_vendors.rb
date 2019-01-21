class BreakdownBusinessAddressFromVendors < ActiveRecord::Migration[5.0]
  def change
    rename_column :vendors, :business_address, :suburb
    add_column :vendors, :street_address, :string
    add_column :vendors, :state, :string
    add_column :vendors, :country, :string
    add_column :vendors, :post_code, :string
  end
end
