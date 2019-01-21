class RemoveVendorReferenceToReferrals < ActiveRecord::Migration[5.0]
  def change
    remove_column :referrals, :vendor_id
  end
end
