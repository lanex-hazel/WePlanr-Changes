class Client::Organisr::OutsideVendorsController < Client::BaseController
  include CRUD

  def create
    @_obj = obj_class.new(obj_params)

    if obj.save
      update_oustanding_todo
      render json: {success: true}, status: 201
    else
      render_422 obj
    end
  end

  def update
    if obj.update(obj_params)
      render json: {success: true}
    else
      render_422 obj
    end
  end


  private


  def obj_class
    collection
  end

  def collection
    @_collection ||= current_user.wedding.outside_vendors
  end

  def obj_params
    # NOTE: accepts attrs from 3 models
    #   budget
    #   custom_todo
    params.require(:data).require(:attributes).permit(*%i(
      status planned
      name category timing_min_month timing_max_month
      slug business_name public_contact_name address_summary email website primary_phone
      total_fee paid budget_id custom_todo_id
    ))
  end

  def update_oustanding_todo
    if obj_params[:budget_id].present?
      current_user.wedding.update_outstanding_todo
    end
  end
end
