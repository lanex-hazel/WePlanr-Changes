class Client::InvoiceDetailsSerializer < ActiveModel::Serializer
  attributes *%i(
    invoice_no status created_at updated_at
    description quote_id
  )

  attribute :quote_items do
    quote.quote_items.map do |item|
      item.attributes.slice(*%w(name description quantity cost total))
    end
  end

  attribute :quote do
    quote.attributes.slice(*%w(
      quote_no payment_due delivery_date
      is_gst status created_at
    ))
  end

  attribute :payment do
    {
      subtotal: quote.subtotal,
      total_gst: quote.total_gst,
      total: quote.total,
      amount_due: quote.amount_due
    }
  end

  attribute :wedding do
    object.wedding.name
  end

  attribute :vendor do
    vendor = object.vendor
    {
      business_name: vendor.business_name,
      business_number: vendor.business_number
    }
  end

  def quote
    @_quote ||= object.quote
  end

end
