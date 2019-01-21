class AddCustomVendorFeePcgToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :custom_vendor_fee_pcg, :integer
  end
end
