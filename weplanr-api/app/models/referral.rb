class Referral < ApplicationRecord
  PENDING = "pending"
  ACCEPTED = "accepted"

  belongs_to :referrer, polymorphic: true
  has_many :discount_items

  scope :pending, ->{ where(registered_date: nil) };
  scope :successful, ->{ where.not(registered_date: nil) }; def self.success; successful; end
  scope :customer, ->{ where(referrer_type: 'Wedding') }
  scope :vendor, ->{ where(referrer_type: 'Vendor') }
  validates :referred_email, presence: true
  validate :referred_email_uniqueness
  validate :existing_vendor
  validate :is_feature_available

  def self.is_referred? email
    where(referred_email: email, status: ACCEPTED).exists?
  end

  def referred_email_uniqueness
    if Referral
      .where(referrer_id: referrer_id, referred_email: referred_email)
      .where.not(id: id).exists? && referred_email.present?
      errors.add(:base, 'This vendor has been referred')
    end
  end

  def referred_vendor
    Vendor.find_by_email referred_email
  end

  def existing_vendor
    if Vendor.find_by_email(referred_email) &&  status != ACCEPTED && referred_email.present?
      errors.add(:base, 'Email is already a registered vendor')
    end
  end

  def is_feature_available
    errors.add(:base, 'This feature is currently not available.</br>Please contact our support team.') if is_not_available?
  end

  private

  def user_referral
    reward = Feature.find(1)
    reward.status
  end

  def vendor_referral
    reward = Feature.find(2)
    reward.status
  end

  def is_not_available?
    referrer.is_a?(Wedding) && user_referral == 0 || referrer.is_a?(Vendor) && vendor_referral == 0
  end

end
