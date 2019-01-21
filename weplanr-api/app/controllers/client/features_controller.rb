class Client::FeaturesController < Client::BaseController
  include CRUD

  skip_before_action :authenticate!

  private
  
  def obj_class
    Feature
  end

  def serializer
    Client::FeatureSerializer
  end
end
