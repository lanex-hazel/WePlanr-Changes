class RemoveRegisteredBusinessAddressToVendors < ActiveRecord::Migration[5.0]
  def change
    remove_column :vendors, :registered_business_address, :string
  end
end
