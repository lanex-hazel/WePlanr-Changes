class AddPublicContactNameToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :public_contact_name, :string
  end
end
