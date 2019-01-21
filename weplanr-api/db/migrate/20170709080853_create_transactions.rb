class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.json :metadata, default: {}

      t.references :owner, index: true, polymorphic: true
      t.references :quote, index: true
      t.timestamps
    end
  end
end
