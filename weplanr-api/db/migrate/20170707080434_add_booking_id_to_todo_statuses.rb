class AddBookingIdToTodoStatuses < ActiveRecord::Migration[5.0]
  def change
    add_reference :todo_statuses, :booking, index: true
  end
end
