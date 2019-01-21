class UpdateColumnsToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :registered_date, :datetime
    add_column :referrals, :gift_card_sent, :boolean, default: false
    remove_column :referrals, :discount_fee, :decimal
  end
end
