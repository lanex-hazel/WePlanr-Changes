class TodoStatus < ApplicationRecord

  PENDING = 'pending'
  BOOKED = 'booked'
  REMOVED = 'removed'

  belongs_to :wedding
  belongs_to :todo, -> { includes :booking }
  belongs_to :booking
  belongs_to :outside_vendor

  scope :not_pending, ->{ where.not(status: PENDING) }
  scope :not_removed, ->{ where.not(status: REMOVED) }
  scope :booked, ->{ where(status: BOOKED) }

  def restore
    self.status = PENDING
    save
  end

  def removed?
    status.eql? REMOVED
  end

  def remove
    self.status = REMOVED
    self.save
  end

  def unremove
    self.delete
  end

end
