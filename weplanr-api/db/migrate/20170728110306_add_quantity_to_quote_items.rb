class AddQuantityToQuoteItems < ActiveRecord::Migration[5.0]
  def change
    add_column :quote_items, :quantity, :integer, default: 1
  end
end
