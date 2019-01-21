class AddOverdueAtToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :overdue_at, :datetime
  end
end
