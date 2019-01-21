class AddInternalIdToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :internal_id, :string
    add_index :vendors, [:business_number, :internal_id], unique: true
  end
end
