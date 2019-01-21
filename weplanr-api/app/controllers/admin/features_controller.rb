class Admin::FeaturesController < Admin::BaseController
  include CRUD

  private
  
  def obj_class
    Feature
  end

  def collection
    Feature.all.order('name asc')
  end

  def obj_params
    params.require(:data).require(:attributes).permit *%w(
      status
    )
  end

  def serializer
    Admin::FeatureSerializer
  end
end
