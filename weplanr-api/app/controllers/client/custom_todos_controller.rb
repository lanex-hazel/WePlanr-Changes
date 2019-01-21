class Client::CustomTodosController < Client::BaseController
  include CRUD

  # def update
  #   update_params.each do |param|
  #     obj.update param.permit(*%i(
  #     status booking_id outside_vendor_id
  #   ))
  #     render_common_response
  #   end
  # end

  private

  def obj
    @_obj ||= obj_class.find params[:id]
  end

  def collection
    current_user.wedding.custom_todos
  end
  
  def obj_class
    collection
  end

  def obj_params
    params.require(:data).require(:attributes).permit(*%i(
      name status booking_id outside_vendor_id planned
    ))
  end

  def update_params
    params.require(:data).require(:attributes)
  end

end