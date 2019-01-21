class AddRegisteredTradingNameToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :registered_trading_name, :string
  end
end
