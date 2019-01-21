class AddNonProfitToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :non_profit, :boolean, default: false
  end
end
