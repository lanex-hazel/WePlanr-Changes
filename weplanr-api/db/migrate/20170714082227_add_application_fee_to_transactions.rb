class AddApplicationFeeToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :application_fee, :decimal
  end
end
