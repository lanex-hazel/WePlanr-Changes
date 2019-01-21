class CreateRewardTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :reward_transactions do |t|
      t.references :quote, index: true
      t.references :wedding, index: true
      t.boolean :gift_card_sent, default: false
      t.timestamps
    end
  end
end
