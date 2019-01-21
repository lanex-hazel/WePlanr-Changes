class AddAnchorToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :anchor, :boolean, default: false
  end
end
