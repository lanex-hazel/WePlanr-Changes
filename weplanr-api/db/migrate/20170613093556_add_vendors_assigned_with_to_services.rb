class AddVendorsAssignedWithToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :vendors_assigned_with, :integer, default: 0
  end
end
