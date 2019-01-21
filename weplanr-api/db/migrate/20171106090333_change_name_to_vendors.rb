class ChangeNameToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :firstname, :string
    add_column :vendors, :lastname, :string
  end
end
