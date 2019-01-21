class RemovePersonalNameToVendors < ActiveRecord::Migration[5.0]
  def change
    remove_column :vendors, :personal_name, :string
  end
end
