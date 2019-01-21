class Client::WeddingsController < Client::BaseController
  include CRUD

  def profile
    # binding.pry
    obj = obj_class.find_by_uid(params[:uid])
    # binding.pry
    render json: obj, serializer: serializer
  end

  private

  def obj
    current_user.wedding
  end

  def obj_params
    params.require(:data).require(:attributes).permit(*%i(budget date location))
  end

  def serializer
    Client::WeddingSerializer
  end

  def obj_class
    Wedding
  end
end
