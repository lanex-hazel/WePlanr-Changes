class Client::Organisr::BookingsController < Client::BaseController
  include CRUD

  def link
    if obj.update(booking_id: params[:id], status: TodoStatus::BOOKED)
      current_user.wedding.update_outstanding_todo
      render json: {success: true}
    else
      render_422 obj
    end
  end


  private

  def obj
    @_obj ||=
      begin
        id = params[:todo_id]

        case params[:type]
        when 'custom_todos'
          wedding.custom_todos.find(id)
        else
          wedding.budgets.find(id).todo_status
        end
      end
  end

  def wedding
    @_wedding = current_user.wedding
  end

end
