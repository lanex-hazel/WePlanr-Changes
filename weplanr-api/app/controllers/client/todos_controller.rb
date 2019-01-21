class Client::TodosController < Client::BaseController
  include CRUD

  def dashboard
    if collection.any?

      @_collection = collection
        .sort_by{ |todo| [todo.timing_min_month.to_i * -1, (todo.is_a?(Organisr::DefaultTodo) ? todo.position : (todo.id + 999))] }
        .in_groups_of(6)
        .find{ |group| group.compact.any?{ |todo| todo.status == 'pending' } }
        &.compact || []
    else
      @_collection = Todo.limit(6)
    end

    index
  end


  private


  def collection
    @_collection ||=
      begin
        organisr = Organisr.new(current_user.wedding, [:todo_statuses, :budgets, :services])
        result = organisr.todos

        if params[:services].present?
          service_ids = Service.where(name: params[:services]).pluck(:id)
          result = result.select{ |todo| service_ids.include? todo.service_id }
        end

        if not params[:include_removed].present?
          result = result.reject{ |todo| todo.status == TodoStatus::REMOVED }
        end

        result
      end
  end

  def serializer
    Client::TodoSerializer
  end

end
