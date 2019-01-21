class AddUidToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :uid, :string
  end
end
