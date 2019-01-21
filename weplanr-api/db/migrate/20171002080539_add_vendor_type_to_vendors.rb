class AddVendorTypeToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :vendor_type, :string, default: 'standard'
  end
end
