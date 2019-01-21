class Admin::QuoteBreakdownSerializer < ActiveModel::Serializer
  include FeeCalculator

  attributes *%i(
    id created_at delivery_date updated_at
    payment_due status accepted_at fulfilled_at
    vendor_type quote_no
  )
  attribute :expiry_date do
    object.created_at + 6.day
  end

  attribute :payment do
    subtotal = object.subtotal
    app_fee = calculate_application_fee(object)

    {
      total: subtotal,
      due: object.amount_due,
      vendor_gst: object.total_gst,
      fee_standard_pcg: calculate_weplanr_fee_pcg(subtotal) * 100,
      fee_custom_pcg: vendor.custom_vendor_fee_pcg,
      fee_custom_flat: custom_flat,
      wp_trnsct_fee: app_fee,
      wp_gst: app_fee * 0.10,
    }
  end

  attribute :downpayment do
    invoices.deposit.map { |item| serialize_invoice(item) }
  end

  attribute :finalpayment do
    invoices.due.map { |item| serialize_invoice(item) }
  end

  attribute :immediatepayment do
    invoices.full.map { |item| serialize_invoice(item) }
  end

  attribute :items do
    object.quote_items.map { |item| serialize_obj(item) }
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
      business_number: vendor.business_number,
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

  def custom_flat
    object.custom_vendor_fee_flat || 0
  end

  def serialize_obj obj
    Admin::QuoteItemSerializer.new(obj).as_json
  end

  def serialize_invoice invoice
    Admin::InvoiceSerializer.new(invoice).as_json
  end
end
