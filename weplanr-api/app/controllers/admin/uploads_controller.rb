class Admin::UploadsController < Admin::BaseController
  include ArraySerializer

  def vendor_csv
    data = VendorCsvParser.parse(params[:file].tempfile)

    result = Vendor.transaction do
      data.map{ |row| Vendor.create(row) }
    end

    render json: serialize_array_with_errors(result, Admin::VendorSerializer), status: 201
  end

  def vendor_photos
    vendor = Vendor.find(params[:id])
    photos = if vendor_params[:photo]
               [vendor_params[:photo]]
             else
               vendor_params[:photos]
             end

    result = photos.map do |photo|
      vendor.photos.create(image: photo)
    end

    render json: { data: result }, status: 201
  end

  private

  def vendor_params
    params.require(:vendor).permit(:id, :profile_photo, :photo, photos: [])
  end
end
