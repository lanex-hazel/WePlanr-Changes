class UnavailableDate < ApplicationRecord
  belongs_to :vendor, touch: true
  validates :date, uniqueness: {scope: :vendor_id}, presence: true
  validates :reason, inclusion: { in: %w(closed fullybooked)}

  def self.get_by_reason reason
    self.where('reason = ?', reason)
  end
end
