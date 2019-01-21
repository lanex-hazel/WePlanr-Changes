class Admin::TodosController < Admin::BaseController
  include CRUD

  def index
    render json: serialize_array(collection, serializer)
  end

  private
  
  def obj_class
    Todo
  end

  def collection
    Todo.all
  end

  def obj_params
    params.require(:data).require(:attributes).permit *%w(
      name
      timing_min_month timing_max_month
      suggestion_copy reminder_copy question_copy redirect_copy
    )
  end

  def serializer
    Admin::TodoSerializer
  end
end
