class Client::OrganisrController < Client::BaseController
  include CRUD

  def create
    @_obj = obj_class.new(obj_params)

    if obj.save
      render json: {
        data: {
          attributes: { id: obj.id }
        }
      }, status: 201
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

  def destroy
    if obj.remove && current_user.wedding.update_outstanding_todo
      render json: {}, status: 204
    else
      render_422 obj
    end
  end

  def restore
    if obj.restore && current_user.wedding.update_outstanding_todo
      render json: {success: true}
    else
      render_422 obj
    end
  end


  def categories
    render json: { data: TodoCategory.pluck(:name) }
  end


  private

  def obj_params
    # NOTE: accepts attrs from 3 models
    #   budget
    #   custom_todo
    params.require(:data).require(:attributes).permit(*%i(
      status planned
      name service_id service_name timing_min_month timing_max_month
    ))
  end

  def obj
    @_obj ||= obj_class.find(params[:id])
  end

  def obj_class
    case params[:type]
    when 'custom_todos'
      wedding.custom_todos
    else
      wedding.budgets
    end
  end

  def collection
    @_collection ||= Organisr.new(current_user.wedding).todos
  end

  def wedding
    @_wedding = current_user.wedding
  end

  def serializer
    Client::Organisr::TodoSerializer
  end

end
