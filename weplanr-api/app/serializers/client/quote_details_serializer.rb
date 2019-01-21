class Client::QuoteDetailsSerializer < ActiveModel::Serializer
  attributes *%i(
    quote_no status created_at updated_at
    payment_due delivery_date
    is_gst subtotal total_gst total amount_due
  )

  attribute :referral_discount, key: :discount

  attribute :quote_items do
    object.quote_items.map do |item|
      item.attributes.slice(*%w(name description quantity cost total))
    end
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

end
