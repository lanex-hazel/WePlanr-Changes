class MoveVendorsAssignedWithToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :vendors_assigned_with, :integer, default: 0
    remove_column :services, :vendors_assigned_with, :integer, default: 0
  end
end
