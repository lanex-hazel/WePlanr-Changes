class DropUserAndVendorCodes < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_referral_codes
    drop_table :vendor_promo_codes
  end
end
