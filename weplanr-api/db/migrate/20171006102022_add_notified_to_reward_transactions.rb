class AddNotifiedToRewardTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :reward_transactions, :notified, :boolean, default: false
  end
end
