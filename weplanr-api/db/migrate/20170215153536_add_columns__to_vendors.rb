class AddColumnsToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :business_address, :string
    add_column :vendors, :address_summary, :string
    add_column :vendors, :primary_phone, :string
    add_column :vendors, :secondary_phone, :string
    add_column :vendors, :contact_name, :string
    add_column :vendors, :about, :string
    remove_column :vendors, :phone, :string
  end
end
