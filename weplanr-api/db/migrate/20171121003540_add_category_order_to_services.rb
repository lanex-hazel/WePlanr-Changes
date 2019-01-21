class AddCategoryOrderToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :category_order, :integer
  end
end
