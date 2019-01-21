class DropQuoteDrafts < ActiveRecord::Migration[5.0]
  def change
    drop_table :quote_drafts
    drop_table :quote_draft_items
  end
end
