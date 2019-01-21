class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.references :vendor, index: true
      t.references :wedding, index: true
      t.boolean :is_gst
      t.datetime :payment_due
      t.string :quote_no
      t.timestamps
    end
  end
end
