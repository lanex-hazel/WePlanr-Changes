class Quote < ApplicationRecord
  ACCEPTED = 'accepted'
  DRAFT = 'draft'
  OFFERED = 'offered'
  REJECTED = 'rejected'
  EXPIRED = 'expired'
  FULFILLED = 'fulfilled'
  DEPOSIT = 'deposit'
  DUE = 'due'
  FULL = 'full'

  belongs_to :vendor
  belongs_to :wedding
  has_one :booking
  has_many :invoices
  has_many :payouts
  has_many :transactions
  has_many :quote_items, dependent: :destroy
  has_one :message, dependent: :destroy
  has_many :discount_items
  has_many :reward_transactions

  before_create :assign_quote_no
  before_create :assign_expiry_date

  scope :drafts, ->{ where(status: DRAFT) }
  scope :offered, ->{ where(status: OFFERED) }
  scope :accepted, ->{ where(status: ACCEPTED) }
  scope :booked, ->{ where('status = ? or status = ?', ACCEPTED, FULFILLED)}
  scope :for_expiry, ->{ offered.where('created_at < ?', 7.days.ago.beginning_of_day) }
  scope :expired, ->{ where(status: EXPIRED) }
  scope :on_due, ->{ accepted.where('payment_due < ?', Time.current) }
  scope :search_by_status, ->(status) { where(status: status) }


  def subtotal
    quote_items.map(&:total).sum
  end

  def total
    quote_items.sum(:total).to_f.round(2)
  end

  def total_gst
    total - subtotal
  end

  def total_with_discount
    total - referral_discount
  end

  def amount_due
    total - total_paid
  end

  def amount_due_pct
    amount_due / total
  end

  #def amount_due_with_discount
    #total_with_discount - total_paid
  #end

  def total_paid
    transactions.sum :amount
  end

  def accept
    update status: ACCEPTED, accepted_at: Time.current
  end

  def fulfill
    update status: FULFILLED, fulfilled_at: Time.current, accepted_at: (accepted_at || Time.current)
  end

  def reject
    update status: REJECTED
  end

  def update_vendor_settings
    update vendor_type: vendor.vendor_type, custom_vendor_fee_flat: vendor.custom_vendor_fee_flat, custom_vendor_fee_pcg: vendor.custom_vendor_fee_pcg
  end

  def draft?
    status.eql? DRAFT
  end

  def discounted?
    discount_items.present?
  end

  def referral_discount
    discount_items.sum :price
  end

  def invoice
    invoices.create(
      wedding: self.wedding,
      vendor: self.vendor,
      quote: self,
      invoice_no: self.quote_no+'A',
    )
  end

  def deposit_invoice
    obj = invoice
    obj.update(
      amount: self.total * 0.40,
      description: DEPOSIT)

    obj
  end

  def due_invoice
    obj = invoice
    obj.update(
      amount: self.amount_due,
      due_at: self.payment_due,
      invoice_no: self.quote_no+'B',
      description: DUE)

    obj
  end

  def full_invoice
    obj = invoice
    obj.update(
      amount: self.amount_due,
      due_at: self.payment_due,
      description: FULL)

    obj
  end

  def expiry_format
    expires_at.strftime("%d.%m.%Y")
  end


  private

  def assign_quote_no
    year = DateTime.current.strftime('%y')
    vendor_internal_id = sprintf('%02d', vendor.internal_id[/([^\.]+)$/])
    vendor_type = sprintf('%02d', vendor.primary_service_id)
    num = Quote.where(vendor_id: vendor_id).count + 1
    write_attribute :quote_no, vendor_type.concat(vendor_internal_id,year,num.to_s)
  end

  def assign_expiry_date
    write_attribute :expires_at, DateTime.current + 6.day
  end
end
