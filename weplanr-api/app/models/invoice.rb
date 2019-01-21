class Invoice < ApplicationRecord
  extend FriendlyId

  UNPAID = 'unpaid'
  PAID = 'paid'
  DEPOSIT = 'deposit'
  DUE = 'due'
  FULL = 'full'

  friendly_id :invoice_no, use: :finders

  scope :unpaid, ->{ where(status: UNPAID) }
  scope :paid, ->{ where(status: PAID) }
  scope :overdue, ->{ unpaid.where('due_at < ?', Time.current) }
  scope :search_by_status, ->(status) { where(status: status) }
  scope :deposit, ->{ where(description: DEPOSIT) }
  scope :due, ->{ where(description: DUE) }
  scope :full, ->{ where(description: FULL) }

  belongs_to :quote
  belongs_to :wedding
  belongs_to :vendor
  has_many :transactions

  def paid
    update status: PAID
  end

  def due_date_format
    due_at.strftime("%d.%m.%Y")
  end
end
