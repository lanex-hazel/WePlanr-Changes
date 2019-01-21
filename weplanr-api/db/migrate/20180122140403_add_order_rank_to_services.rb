class AddOrderRankToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :order_rank, :integer, default: 1
  end
end
