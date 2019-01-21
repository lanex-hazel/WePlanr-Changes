class Client::PricingAndPackagesController < Client::BaseController
  include CRUD

  private

  def vendor
    @_vendor ||= current_user.vendors.find params[:my_vendor_id]
  end

  def collection
    vendor.pricing_and_packages
  end

  def obj_params
    params.require(:data).require(:attributes).permit(:name, :price)
  end

  def obj_class
    collection
  end

  def serializer
    Client::PricingAndPackageSerializer
  end
end
