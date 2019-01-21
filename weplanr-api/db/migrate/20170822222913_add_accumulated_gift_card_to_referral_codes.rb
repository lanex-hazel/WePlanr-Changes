class AddAccumulatedGiftCardToReferralCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :referral_codes, :accumulated_gift_card, :integer, default: 0
  end
end
