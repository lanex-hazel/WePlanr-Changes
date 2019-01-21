class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.decimal :amount
      t.string :description
      t.string :status, default: 'unpaid'
      t.references :quote, index: true
      t.references :wedding, index: true
      t.references :vendor, index: true
      t.timestamps
    end
  end
end
