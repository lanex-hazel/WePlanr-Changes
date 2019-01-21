class Client::PhotosController < Client::BaseController
  include CRUD

  def create
    photos = if photos_params[:photo]
               [photos_params[:photo]]
             else
               photos_params[:photos]
             end

    result = photos.map do |photo|
      vendor.photos.create(image: photo)
    end

    render json: { data: result }, status: 201
  end

  private

  def obj
    @_obj ||= vendor.photos.find params[:id]
  end

  def vendor
    @_vendor ||= current_user.vendors.find params[:my_vendor_id]
  end

  def photos_params
    params.require(:vendor).permit(:photo, photos: [])
  end
end
