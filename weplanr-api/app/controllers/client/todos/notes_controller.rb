class Client::Todos::NotesController < Client::BaseController
  include CRUD

  def create
    @_obj = collection.where(noteable_id: params['todo_id'], noteable_type: obj_params['noteable_type']).first_or_create
    @_obj.content = obj_params[:content]

    if @_obj.save
      render_common_response
    else
      render_422 @_obj
    end
  end

  private
  def collection
    current_user.wedding.todo_notes
  end

  def obj_params
    params.require(:data).require(:attributes).permit(*%i(
      noteable_id noteable_type content
    ))
  end

end