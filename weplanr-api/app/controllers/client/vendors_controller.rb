class Client::VendorsController < Client::BaseController
  include CRUD
  include SearchConcern

  skip_before_action :authenticate!, only: %i(index show events)
  after_action :log_view, only: :show
  after_action :log_favorite, only: :favorite


  def index
    if params[:group_by].present?
      data = params[:group_by].eql?('service') ? collection_by_service : collection_by_location
      render json: {data: data}
    else
      super
    end
  end


  def featured
    data = current_user.wedding.pending_todos.map do |todo|
      Vendor.search_by_services(todo.service.name).reorder("RANDOM()").limit(1).first if todo.service
    end

    render json: serialize_array(data.compact)
  end


  def favorite
    user = current_user.wedding&.users&.find{ |u| u.favorites.any? } || current_user
    render json: {success: user.favorites.create!(vendor: obj)}
  end


  def unfavorite
    user = current_user.wedding&.users&.find{ |u| u.favorites.any? } || current_user
    render json: {success: user.favorites.find_by(vendor: obj).destroy}
  end

  def cover_photo
    photo = Photo.find(params[:photo_id])
    obj.update cover_photo: photo.image

    render json: obj, serializer: Client::VendorSerializer
  end


  def events
    day = params[:date].present? ? Date.parse(params[:date], '%d/%m/%Y') : Date.today
    range = day.at_beginning_of_month..day.at_end_of_month
    render json:{
      data: {
        bookings: obj.bookings.where(schedule: range).map(&:eventDay),
        closed: obj.unavailable_dates.get_by_reason('closed').where(date: range).map(&:date),
        fullybooked: obj.unavailable_dates.get_by_reason('fullybooked').where(date: range).map(&:date)
      }
    }
  end


  private


  def collection_by_service
    data = {}

    Service.all.each do |service|
      result = Vendor.search_by_services(service.name)
      records = apply_search(result).limit(params[:limit] || 4)
      data[service.name] = serialize_array(records)[:data]
    end

    data
  end

  def collection_by_location
    data = {}

    Location.defaults.pluck(:name).each do |location|
      records = collection.search_by_locations(location).limit(4)
      data[location] = serialize_array(records)[:data]
    end

    data
  end

  def collection_by_general
    apply_search(Vendor.all)
  end

  def collection_with_exact_match
    @_collection_with_exact_match = collection_by_general.where("lower(business_name) = ?", search_query.downcase)
  end

  def collection
    @_collection ||= collection_with_exact_match.present? ? collection_with_exact_match : collection_by_general
  end

  def obj_class
    Vendor
  end

  def serializer
    Client::VendorSerializer
  end

  def log_favorite
    obj.logs.favorites.create log_stats
  end

  def log_view
    tz = request.headers['HTTP_TIMEZONE'] || '+10:00' # default: AUS EST
    start_time = DateTime.parse(tz)
    end_time = start_time + 1.day - 1.second

    obj.logs.views.create(log_stats) if not obj.logs.views.where(ip_address: request.remote_ip, created_at: start_time..end_time).exists?
  end

  def log_stats
    {
      ip_address: request.remote_ip,
      user: current_user,
      vendor: obj,
    }
  end

end
