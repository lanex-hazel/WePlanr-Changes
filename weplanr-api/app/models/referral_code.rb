class ReferralCode < ApplicationRecord
  belongs_to :owner, polymorphic: true

  after_initialize :validate_code

  def validate_code
    errors.add(:base, 'Referral code is invalid') unless id.present?
  end
end