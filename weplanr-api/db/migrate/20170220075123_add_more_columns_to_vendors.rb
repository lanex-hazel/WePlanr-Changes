class AddMoreColumnsToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :services, :string
    add_column :vendors, :pricing_and_packages, :text
    add_column :vendors, :registered_for_gst, :string
    add_column :vendors, :registered_business_address, :text
  end
end
