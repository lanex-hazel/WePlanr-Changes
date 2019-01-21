class Client::QuoteSerializer < ActiveModel::Serializer
  attributes *%i(
    payment_due status updated_at quote_no is_gst
    delivery_date created_at accepted_at
  )

  attribute :quote_items do
    object.quote_items.map do |item|
      item.attributes.slice(*%w(name description quantity cost total))
    end
  end

  attribute :expires_at do
    object.created_at + 6.day
  end

  attribute :fee do
    {
      total: object.total,
      subtotal: object.subtotal,
      paid: object.total_paid,
    }
  end

  attribute :vendor do
    {
      name: vendor&.business_name
    }
  end

  attribute :wedding do
    {
      name: wedding&.name
    }
  end

  attribute :discount do
    object.referral_discount
  end

  attribute :booking do
    {
      id: object.booking&.id
    }
  end

  attribute :invoices do
    {
      deposit: invoices&.deposit.pluck(:invoice_no),
      due: invoices&.due.pluck(:invoice_no),
      full: invoices&.full.pluck(:invoice_no)
    }
  end

  def vendor
    @_vendor ||= object.vendor
  end

  def wedding
    @_wedding ||= object.wedding
  end

  def invoices
    @_invoices ||= object.invoices
  end
end
