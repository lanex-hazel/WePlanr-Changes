class Client::ServicesController < Client::BaseController
  include ArraySerializer

  skip_before_action :authenticate!

  def index
    records = collection

    render json: serialize_array(records, Client::ServiceSerializer)
  end

  def collection
    @_collection ||=
      begin
        if params[:primary].present?
          obj_class.primary
        else
          obj_class
        end.order_by_name
      end
  end

  private

  def obj_class
    Service.includes(:category)
  end
end
