class AddOrderRankToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :order_rank, :integer
  end
end
