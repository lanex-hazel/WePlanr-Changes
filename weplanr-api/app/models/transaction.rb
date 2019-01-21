class Transaction < ApplicationRecord
  PAYMENT_RECEIVED = 'payment received'
  PAYMENT_DEPOSIT = 'Payment deposit'
  PAYMENT_DUE = 'Payment due'

  belongs_to :owner, polymorphic: true
  belongs_to :quote
  belongs_to :invoice
  has_many :payouts

  scope :downpayment, ->{ where(description: PAYMENT_DEPOSIT) }
  scope :finalpayment, ->{ where(description: PAYMENT_DUE) }

  def gst
    amount / 11
  end

  def amount_without_gst
    amount / 1.1
  end

  private

end
