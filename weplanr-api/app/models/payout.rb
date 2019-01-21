class Payout < ApplicationRecord
  PENDING = 'pending'
  PAID = 'paid'
  FAILED = 'failed'

  belongs_to :quote
  belongs_to :vendor
  belongs_to :transaksyon, class_name: :Transaction, foreign_key: 'transaction_id'

  scope :pending, ->{
    where(status: PENDING, scheduled_at: nil)
      .or( where('status ? AND scheduled_at < ?', PENDING, Time.current) )
      .or( where('status ? AND scheduled_at < ?', FAILED, Time.current) )
  }

  before_save :sync_to_metadata, if: Proc.new{ |obj| obj.metadata_changed? }

  def sync_to_metadata
    # pending, paid, failed, or canceled
    if _status = metadata['status']
      write_attribute :status, _status
      if status ==  FAILED
        write_attribute :scheduled_at, 1.day.from_now
        write_attribute :rescheduled_count, rescheduled_count + 1
      end
    end
  end
end
