class CreateQuoteDraftItems < ActiveRecord::Migration[5.0]
  def change
    create_table :quote_draft_items do |t|
      t.references :quote_draft, index: true
      t.string :name
      t.text :description
      t.decimal :cost
      t.decimal :total
    end
  end
end
