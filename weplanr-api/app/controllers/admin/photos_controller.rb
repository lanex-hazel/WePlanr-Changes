class Admin::PhotosController < Admin::BaseController
  include CRUD

  def obj_class
    Photo
  end
end
