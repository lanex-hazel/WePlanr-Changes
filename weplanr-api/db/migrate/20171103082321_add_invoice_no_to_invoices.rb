class AddInvoiceNoToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :invoice_no, :string
  end
end
