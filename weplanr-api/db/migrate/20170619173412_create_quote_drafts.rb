class CreateQuoteDrafts < ActiveRecord::Migration[5.0]
  def change
    create_table :quote_drafts do |t|
      t.references :vendor, index: true
      t.string :name
      t.timestamps
    end
  end
end
