class Client::ProfilesController < Client::BaseController
  include CRUD
  include SearchConcern

  def favorites
    user = current_user.wedding&.users&.find{ |u| u.favorites.any? } || current_user

    @_serializer = Client::FavoriteSerializer
    @_collection = apply_search(user.favorite_vendors)

    index
  end

  def destroy
    current_user.wedding.deactivate

    render json: {}, status: 204
  end

  def calendar
    render json: {
      data: {
        quotes: quotes,
        invoices: invoices
      }
    }
  end

  private

  def collection
    @_collection
  end

  def obj
    @_obj ||= ProfileUpdater.new(current_user)
  end

  def obj_params
    @_obj_params ||=
      begin
        metadata_event = params.require(:data).require(:attributes)[:metadata_event]
        partner = params.require(:data)[:attributes][:partner]

        params[:data].require(:attributes).permit(*%i(
            email firstname lastname phone
            password profile_photo role
            msg_notif_setting
          )
          .push(wedding_details: %i(budget date location no_of_guests))
          .push(metadata_event: metadata_event.present? ? metadata_event.keys : [])
          .push(partner: partner.present? ? partner.keys : [])
        )
      end
  end

  def serializer
    @_serializer ||= current_user.is_vendor? ? Client::VendorProfileSerializer : Client::ProfileSerializer
  end

  def wedding
    @_wedding ||= current_user.wedding
  end

  def invoices
    data = filter_by_date(wedding.invoices.unpaid,
        attr: :due_at,
        date_since: params[:created_since],
        date_until: params[:created_until]
      )
    serialize_data(data, Client::InvoiceSerializer, attr: :due_date_format)
  end

  def quotes
    data =filter_by_date(wedding.quotes.offered,
        attr: :expires_at,
        date_since: params[:created_since],
        date_until: params[:created_until]
      )
    serialize_data(data, Client::QuoteSerializer, attr: :expiry_format)
  end

  def serialize_data records, serializer, attr: :created_format
    records.group_by(&attr).map do |key, val|
     {
        "#{key}": 
          {

            record_count: val.length,
            data: val.map { |obj| serialize_obj(obj, serializer) }
          }
      }
    end
  end
end
