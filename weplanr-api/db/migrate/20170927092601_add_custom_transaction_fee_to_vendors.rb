class AddCustomTransactionFeeToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :custom_transaction_fee, :integer
  end
end
