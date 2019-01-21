class AddFulfilledAtToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :fulfilled_at, :datetime
  end
end
