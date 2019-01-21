class Client::BookingsController < Client::BaseController
  include CRUD

  def index
    records = collection
    date = params[:date].present? && !params[:view_type].eql?('year') ? Date.parse(params[:date]) : Date.today
    if params[:view_type].eql?('month')
      records = collection.by_month date
    elsif params[:view_type].eql?('year')
      records = collection.by_year params[:date]
      return render json: {data: records}
    elsif params[:view_type].eql?('day')
      records = collection.by_day date
      return render json: serialize_array(records, serializer)
    end
    render json: events_array(records, serializer)
  end

  private

  def vendor
    @_vendor ||= current_user.vendors.find params[:my_vendor_id]
  end

  def collection
    vendor.bookings
  end

  def obj_params
    params.require(:data).require(:attributes).permit(:schedule, :client, :location, :details)
  end

  def obj_class
    collection
  end

  def serializer
    Client::BookingSerializer
  end

  def events_array records = collection, each_serializer = serializer
    {
      data: records.group_by(&:eventDate).map do |event_date, booking_list|
        {
          event_date: event_date,
          bookings: booking_list.count,
          availability: check_availability(event_date),
          schedules: booking_list.map do |obj|
            {
              attributes: each_serializer.new(obj).as_json
            }
          end
        }
      end
    }
  end

  def check_availability date
    available = UnavailableDate.find_by_date date
    return available.reason if available.present?
  end

end
