class ChangeDeliveryDateFormatFromQuotes < ActiveRecord::Migration[5.0]
  def up
    change_column :quotes, :delivery_date, :datetime
  end

  def down
    change_column :quotes, :delivery_date, :date
  end
end
