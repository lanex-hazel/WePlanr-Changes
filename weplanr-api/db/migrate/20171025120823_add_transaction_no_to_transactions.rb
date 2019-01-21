class AddTransactionNoToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :transaction_no, :string
  end
end
