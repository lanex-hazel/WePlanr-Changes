class AddDiscountFeeToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :discount_fee, :decimal, default: 0
  end
end
