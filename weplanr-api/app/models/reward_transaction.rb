class RewardTransaction < ApplicationRecord
  ## Customer transactions/bookings that are more then $500 or more
  belongs_to :wedding
  belongs_to :quote

  scope :sent, ->{ where(gift_card_sent: true) }
end