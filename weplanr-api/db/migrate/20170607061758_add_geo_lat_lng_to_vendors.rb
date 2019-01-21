class AddGeoLatLngToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :address_lat, :decimal
    add_column :vendors, :address_lng, :decimal
  end
end
