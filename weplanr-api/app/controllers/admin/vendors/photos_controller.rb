class Admin::Vendors::PhotosController < Admin::BaseController
  include CRUD

  def collection
    vendor.photos
  end

  def vendor
    Vendor.find params[:vendor_id]
  end

  def serializer
    Admin::PhotoSerializer
  end
end
