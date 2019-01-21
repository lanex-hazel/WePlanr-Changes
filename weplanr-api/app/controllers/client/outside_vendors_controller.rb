class Client::OutsideVendorsController < Client::BaseController
  include CRUD

  attr_reader :item

  def create
    @item = obj_class.new(obj_params)
    if item.save
      update_todo
      current_user.wedding.update_users_metadata unless current_user.wedding.is_personalised?
      render json: item, serializer: serializer
    else
      render_422 item
    end
  end

  private

  def obj
    @_obj ||= obj_class.find params[:id]
  end

  def obj_class
    current_user.wedding.outside_vendors
  end

  def obj_params
    params.require(:data).require(:attributes).permit(*%i(
      business_name address_summary
      email public_contact_name primary_phone
      website total_fee paid
    ))
  end

  def default_todo
    @_default_todo ||= Todo.find_by_name(params[:data][:attributes][:todo_item])
  end

  def custom_todo
    @_custom_todo ||= current_user.wedding.custom_todos.find_by_name(params[:data][:attributes][:todo_item])
  end

  def update_todo
    if params[:data][:attributes][:todo_type] == 'Todo'
      item.reload.link_to_defaulttodo default_todo, current_user.wedding
      current_user.wedding.update_outstanding_todo
    else
      item.reload.link_to_customtodo custom_todo, item
    end
  end

  def serializer
    Client::OutsideVendorSerializer
  end


  ## For now budget fetch from vendor bookings
  ## Uncomment if needed
  # def update_budget
  #   fee = obj_params[:total_fee]
  #   if todo_item = item.default_todo_item(default_todo)
  #     todo_item.budget.update(actual: fee, paid: fee)
  #   end
  # end
end