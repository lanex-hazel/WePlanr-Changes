class Admin::InvoiceSerializer < ActiveModel::Serializer
  attributes *%i(amount status description created_at invoice_no updated_at)
end