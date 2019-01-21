class AddVendorTypeFromQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :vendor_type, :string, default: 'standard'
  end
end
