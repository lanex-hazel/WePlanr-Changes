class RemoveNonProfitFromVendors < ActiveRecord::Migration[5.0]
  def up
    non_profits = Vendor.where(non_profit: true)
    non_profits.update_all(
      vendor_type: 'non-profit',
      custom_vendor_fee_flat: 0,
      custom_vendor_fee_pcg: 0
    )

    remove_column :vendors, :non_profit, :boolean
  end

  def down
    add_column :vendors, :non_profit, :boolean, default: false
  end
end
