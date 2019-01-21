class Admin::VendorsController < Admin::BaseController
  include CRUD

  def index
    super(
      confirmed_count: params[:status].eql?('unconfirmed') ? 0 : collection_all_status.confirmed.count,
      unconfirmed_count: params[:status].eql?('confirmed') ? 0 : collection_all_status.unconfirmed.count,
    )
  end

  def csv
    send_data(CSV.generate { |csv|
      csv << %w(Business\ Name Verified First\ Name Last\ Name Email Location Date\ Joined Last\ Seen)

      collection.each do |obj|
        user = obj.user
        attr = [
          obj.business_name,
          user ? 'Yes' : 'No',
          obj.firstname,
          obj.lastname,
          obj.email,
          obj.address_summary,
          obj.created_at.strftime('%-d %b, %Y %I:%M%p %Z'),
          user&.last_activity_at&.strftime('%-d %b, %Y %I:%M%p %Z'),
        ]

        csv << attr
      end
    }, filename: Time.current.strftime('WePlanr Vendors - %-d %b, %Y %k:%M %Z.csv'))
  end

  def update
    vendor = collection.find params[:id]

    @_obj = VendorUpdater.new(vendor, obj_params)
    obj.save

    render_common_response
  end

  def profile_photo
    set_photo_as :profile_photo
  end

  def cover_photo
    set_photo_as :cover_photo
  end

  def invite
    vendor = Vendor.find params[:id]

    vendor.invitation&.destroy && vendor.reload
    obj = vendor.build_invitation

    if obj.save
      VendorMailer.invite(vendor).deliver!
    end

    render json: obj, serializer: Admin::InvitationSerializer
  end


  def custom_auth_token_getter
    params.fetch(:t, false)
  end


  private

  def set_photo_as photo_attr
    photo = Photo.find(params[:photo_id])
    obj = Vendor.find(params[:id])

    obj.update_attribute photo_attr, photo.image

    render json: obj, serializer: Admin::VendorSerializer
  end

  def collection
    @_collection ||= collection_by_status(collection_all_status)
  end

  def collection_all_status
    @_all_status_collection ||=
      begin
        result =
          if business = params[:business_name]
            Vendor.search_by_name(business)
          else
            Vendor
          end

        result = collection_by_created_date(result, :created) if params[:created_since]
        result = collection_by_last_active_date(result, :active) if params[:active_since]

        result.order('created_at DESC')
      end
  end

  def collection_by_status records
    case params[:status]
    when 'confirmed'
      records.confirmed
    when 'unconfirmed'
      records.unconfirmed
    else
      records
    end
  end

  def collection_by_created_date records, param_key
    records.where(created_at: filter_date_range(param_key))
  end

  def collection_by_last_active_date records, param_key
    records.joins(:user).where(users: {
      last_activity_at: filter_date_range(param_key)
    })
  end

  def filter_date_range param_key
    start_date = DateTime.parse(params["#{param_key}_since"])
    end_date = DateTime.parse(params["#{param_key}_until"])

    start_date..end_date
  end

  def obj_class
    Vendor
  end

  def obj_params
    @_obj_params ||=
      begin
        params_data = params.require(:data).require(:attributes)

        params_data.permit(*%i(
            contact_name email internal_id uid
            business_name business_number address_summary
            suburb state registered_street_address registered_suburb
            registered_state registered_country registered_post_code
            public_contact_name primary_phone secondary_phone
            website about vendor_type
            registered_trading_name registered_for_gst insurance
            primary_service_id searchable anchor
            profile_photo cover_photo
            custom_vendor_fee_pcg custom_vendor_fee_flat
            firstname lastname
          )
          .push(tags: [])
          .push(services: [])
          .push(locations: [])
          .push(other_locations: [])
          .push(unavailable_dates: %i(id date reason))
          .push(pricing_and_packages: %i(id name price))
          .push(social_channels: params_data[:social_channels]&.keys || [])
        )
      end
  end

  def serializer
    Admin::VendorSerializer
  end
end
