class AddStatusToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :status, :string, default: Transaction::PAYMENT_RECEIVED
  end
end
