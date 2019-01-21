class AddVendorSettingsToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :custom_vendor_fee_pcg, :integer
    add_column :quotes, :custom_vendor_fee_flat, :integer
  end
end
