class Admin::QuotesController < Admin::BaseController
  include CRUD
  include SearchConcern
  include FeeCalculator

  def show
    render json: obj, serializer: Admin::QuoteBreakdownSerializer
  end

  def bookings
    @_collection = collection.booked
    index
  end

  def csv(type='Quotes')
    send_data(CSV.generate { |csv|
      csv << column_headers

      collection.each do |obj|
        csv << csv_data(obj,type)
      end
    }, filename: Time.current.strftime("WePlanr #{type} - %-d %b, %Y %k:%M %Z.csv"))
  end

  def csv_booked
    @_collection = collection.booked
    csv('Bookings')
  end

  def custom_auth_token_getter
    params.fetch(:t, false)
  end

  private
  
  def obj_class
    Quote
  end

  def collection
    @_collection ||= 
      begin
        data = obj_class.all.includes(:transactions).order(created_at: :desc)
        filter_by_creation_date(data)
      end
  end

  def serializer
    Admin::QuoteSerializer
  end

  def column_headers
    %w(Customer\ name Vendor\ business\ name ABN Date\ raised Expires Quote\ No
      Total\ service\ fee Vendor\ GST WePlanr\ Transaction\ Fee(%) WePlanr\ Transaction\ Fee WePlanr\ GST Date\ of\ Delivery
      Booking\ Fee\ (40%)\ (Booking\ Fee\ Invoice)\ Invoice\ No Booking\ Fee\ (40%)\ (Booking\ Fee\ Invoice) Vendor\ GST WePlanr\ Transaction\ Fee WePlanr\ GST Status Date
      Total\ Final\ Fee\ (60%)\ Invoice\ No Total\ Final\ Fee\ (60%) Vendor\ GST WePlanr\ Transaction\ Fee WePlanr\ GST Due\ Date
      Immediate\ Payment\ Fee Immediate\ Payment\ Fee\ Invoice\ No)
  end

  def compute_percent amt, pcg
    amt * pcg
  end

  def csv_data obj, type
    vendor = obj.vendor
    vendor_gst = obj.total_gst
    subtotal = obj.subtotal

    invoice = obj.invoices
    immediate = invoice.full
    booking = invoice.deposit
    final = invoice.due

    due_on = obj.payment_due&.strftime('%-d/%m/%Y')
    booking_date = obj.accepted_at&.strftime('%-d/%m/%Y')

    ## Transaction fee
    wp_fee = calculate_application_fee(obj)
    booking_wp_fee = compute_percent(wp_fee, 0.40)
    final_wp_fee = wp_fee - booking_wp_fee

    if type == 'Bookings'
      obj.status = 'paid'

      downpayment = booking.sum(:amount)
      finalpayment = final.sum(:amount)
    else
      obj.status = 'accepted'

      downpayment = compute_percent(subtotal, 0.40)
      finalpayment = compute_percent(subtotal, 0.60)
    end

    csv = [
      obj.wedding.name,
      vendor.business_name,
      vendor.business_number,
      obj.created_at.strftime('%-d/%m/%Y'),
      (obj.created_at + 6.day).strftime('%-d/%m/%Y'),
      obj.quote_no,
      subtotal,
      vendor_gst,
      vendor.has_custom_vendor_fee? ? vendor.custom_vendor_fee_pcg : (calculate_weplanr_fee_pcg(subtotal) * 100),
      wp_fee,
      compute_percent(wp_fee, 0.10),
      obj.delivery_date&.strftime('%-d/%m/%Y'),
      booking.first&.invoice_no,
      downpayment,
      compute_percent(vendor_gst, 0.40),
      booking_wp_fee,
      compute_percent(booking_wp_fee, 0.10),
      obj.status.upcase,
      booking_date,
      final.first&.invoice_no,
      finalpayment,
      compute_percent(vendor_gst, 0.60),
      final_wp_fee,
      compute_percent(final_wp_fee, 0.10),
      due_on,
      immediate.first&.invoice_no,
      immediate.sum(:amount)
    ]
  end

end
