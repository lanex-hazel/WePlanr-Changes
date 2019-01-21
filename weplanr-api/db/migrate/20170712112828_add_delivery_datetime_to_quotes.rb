class AddDeliveryDatetimeToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :delivery_date, :date
    add_column :quotes, :delivery_time, :string
  end
end
