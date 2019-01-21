class Client::MyVendorsController < Client::BaseController
  include CRUD

  def update
    vendor = collection.find params[:id]

    @_obj = VendorUpdater.new(vendor, obj_params)
    @_obj.save

    render_common_response
  end

  def earnings
    vendor = collection.first # TODO change when multi-vendor has been implemented
    transactions = vendor.transactions
    accepted_quotes = vendor.quotes.accepted.includes(:quote_items)

    if filter_month = params[:month]&.to_i
      filter_year = params[:year]&.to_i || Time.current.year
      filter_date = DateTime.new(filter_year, filter_month)
      earnings_per_day = {}

      accepted_quotes.where(accepted_at: filter_date..filter_date.end_of_month).each do |q|
        date = q.accepted_at.to_date.strftime('%-d %b')
        earnings_per_day[date] ||= 0
        earnings_per_day[date] += q.quote_items.sum(&:total)
      end

      render json: {
        data: { earnings: earnings_per_day }
      }
    else
      render json: {
        data: {
          total: accepted_quotes.map(&:subtotal).sum,
          paid: transactions.sum(:amount),
          expected: vendor.invoices.unpaid.sum(&:amount),
          held: 0, # TODO: on payment of 60% implementation
          transaction_fees: transactions.sum(:application_fee),
        }
      }
    end
  end

  def statistics
    start_date = params[:start_date].present? ? DateTime.parse(params[:start_date]) : DateTime.current
    end_date = params[:end_date].present? ? DateTime.parse(params[:end_date]) : DateTime.current
    range = start_date.beginning_of_day..end_date.end_of_day

    render json: {
      data: {
        views: obj.logs.where(created_at: range).order(:created_at).map{ |o| {ip_address: o.ip_address, created_at: o.created_at} },
        favorites: obj.logs.favorites.where(created_at: range).count,
        inquiries: obj.logs.inquiries.where(created_at: range).count,
        bookings: obj.logs.bookings.where(created_at: range).count,
        totals: {
          views:     obj.logs.views.select("DATE(logs.created_at::timestamp AT TIME ZONE '#{start_date.zone}') AS date_viewed, ip_address").group('date_viewed, ip_address').length,
          favorites: obj.logs.favorites.distinct.count(:user_id),
          inquiries: obj.logs.inquiries.count,
          bookings: obj.logs.bookings.count,
          invoices: {
            sent: obj.invoices.unpaid.count,
            paid: obj.invoices.paid.count
          },
          quotes: {
            raised: obj.quotes.offered.count,
            accepted: obj.quotes.booked.count
          },
        }
      }
    }
  end

  private

  def collection
    @_collection ||= current_user.vendors
  end

  def obj_params
    @_obj_params ||=
      begin
        social_channels = params.require(:data).require(:attributes)[:social_channels]
        params.require(:data).require(:attributes).permit(*%i(
            business_name business_number address_summary
            suburb state registered_street_address registered_suburb
            registered_state registered_country registered_post_code
            public_contact_name primary_phone secondary_phone
            website about
            registered_trading_name registered_for_gst insurance
            profile_photo address_lat address_lng
            stripe_auth_code custom_transaction_fee
            firstname lastname
            msg_notif_setting
          )
          .push(tags: [])
          .push(services: [])
          .push(pricing_and_packages: %i(id name price))
          .push(locations: [])
          .push(other_locations: [])
          .push(social_channels: social_channels ? social_channels.keys : [])
        )
      end
  end

  def obj_class
    collection
  end

  def serializer
    Client::VendorSerializer
  end
end
