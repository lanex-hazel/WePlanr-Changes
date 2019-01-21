class Client::InvoiceSerializer < ActiveModel::Serializer
  attributes *%i(amount status description created_at invoice_no updated_at due_at)

  attribute :owner do
    object.wedding.name
  end

  attribute :vendor do
    object.vendor.business_name
  end

end
