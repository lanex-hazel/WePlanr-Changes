class Client::LocationsController < Client::BaseController
  include ArraySerializer

  skip_before_action :authenticate!

  def index
    render json: serialize_array(Location.defaults, Client::LocationSerializer)
  end
end
