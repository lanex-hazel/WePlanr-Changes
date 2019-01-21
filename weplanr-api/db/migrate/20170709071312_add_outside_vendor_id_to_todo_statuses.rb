class AddOutsideVendorIdToTodoStatuses < ActiveRecord::Migration[5.0]
  def change
    add_reference :todo_statuses, :outside_vendor, index: true
  end
end
