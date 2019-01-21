class CreateQuoteItems < ActiveRecord::Migration[5.0]
  def change
    create_table :quote_items do |t|
      t.references :quote, index: true
      t.string :name
      t.text :description
      t.decimal :cost, default: 0.0
      t.decimal :total, default: 0.0
    end
  end
end
