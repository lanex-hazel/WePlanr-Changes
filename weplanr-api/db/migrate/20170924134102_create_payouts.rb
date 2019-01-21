class CreatePayouts < ActiveRecord::Migration[5.0]
  def change
    create_table :payouts do |t|
      t.string :status, default: Payout::PENDING
      t.integer :amount, null: false
      t.datetime :scheduled_at
      t.integer :rescheduled_count, null: false, default: 0
      t.json :metadata, default: {}
      t.references :quote, index: true
      t.references :vendor, index: true
      t.references :transaction, index: true

      t.timestamps
    end
  end
end
