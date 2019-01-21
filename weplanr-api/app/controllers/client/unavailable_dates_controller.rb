class Client::UnavailableDatesController < Client::BaseController
  include CRUD

  private

  def vendor
    @_obj ||= current_user.vendors.find params[:my_vendor_id]
  end

  def collection
    vendor.unavailable_dates
  end

  def obj_params
    params.require(:data).require(:attributes).permit(:date, :reason)
  end

  def obj_class
    collection
  end

  def serializer
    Client::UnavailableDateSerializer
  end

  def serialize_array records=collection, each_serializer=serializer, meta={}
    serializer = Client::UnavailableDateDetailSerializer
    {
      data:
      {
        closed: serializer.new(records.get_by_reason('closed')).as_json,
        fullybooked: serializer.new(records.get_by_reason('fullybooked')).as_json
      }
    }
  end
end
