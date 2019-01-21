class RemoveCategoryOrderToServices < ActiveRecord::Migration[5.0]
  def change
    remove_column :services, :category_order, :integer
  end
end
