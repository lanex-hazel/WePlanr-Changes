class AddTotalFeeToOutsideVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :outside_vendors, :total_fee, :decimal
  end
end
