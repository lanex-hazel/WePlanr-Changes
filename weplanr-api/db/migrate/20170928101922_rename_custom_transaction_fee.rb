class RenameCustomTransactionFee < ActiveRecord::Migration[5.0]
  def change
    rename_column :vendors, :custom_transaction_fee, :custom_vendor_fee_flat
  end
end
