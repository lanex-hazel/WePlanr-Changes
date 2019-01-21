class AddQuoteIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :quote, index: true
  end
end
