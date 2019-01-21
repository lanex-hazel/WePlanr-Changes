class Admin::QuoteSerializer < ActiveModel::Serializer
  attributes *%i(
    id quote_no status created_at
    payment_due delivery_date accepted_at
  )

  attribute :payment_breakdown do
    deposit = invoices.deposit
    due = invoices.due
    full = invoices.full
    {
      downpayment: deposit.sum(:amount),
      downpayment_invoice_no:  deposit.first&.invoice_no,
      paid: object.transactions.where.not(description: 'Payment deposit').sum(:amount),
      due: object.amount_due,
      finalpayment: due.sum(:amount),
      finalpayment_invoice_no: due.first&.invoice_no,
      full: full.sum(:amount),
      full_invoice_no: full.first&.invoice_no,
      total: object.subtotal
    }
  end

  attribute :total_invoice do
    invoices.count
  end

  attribute :wedding do
    {
      id: wedding.primary_account.id,
      name: wedding.name,
    }
  end

  attribute :vendor do
    {
      id: vendor.slug,
      name: vendor.business_name,
    }
  end


  def wedding
    @_wedding ||= object.wedding
  end

  def vendor
    @_vendor ||= object.vendor
  end

  def invoices
    @_invoices ||= object.invoices
  end
end
