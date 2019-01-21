class AddCurrentCreditToVendorPromoCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :vendor_promo_codes, :current_credit, :integer, default: 0
  end
end
