class RemoveDeliveryTimeFromQuotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :quotes, :delivery_time, :string
  end
end
