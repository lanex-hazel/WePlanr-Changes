class Budget < ApplicationRecord
  belongs_to :wedding
  belongs_to :todo

  def todo_status
    @_todo_status ||= TodoStatus.find_or_initialize_by(todo_id: todo_id, wedding_id: wedding_id)
  end

  def restore
    todo_status&.restore
  end

  def remove
    todo_status&.remove
  end
end
