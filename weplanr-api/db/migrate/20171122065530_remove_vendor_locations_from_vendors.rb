class RemoveVendorLocationsFromVendors < ActiveRecord::Migration[5.0]
  def change
    remove_column :vendors, :vendor_locations, :string, array: true
  end
end
