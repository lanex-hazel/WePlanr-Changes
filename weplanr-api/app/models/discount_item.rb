class DiscountItem < ApplicationRecord
  belongs_to :quote
  belongs_to :referral
end