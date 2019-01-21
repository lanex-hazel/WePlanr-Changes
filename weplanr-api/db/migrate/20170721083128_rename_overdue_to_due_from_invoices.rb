class RenameOverdueToDueFromInvoices < ActiveRecord::Migration[5.0]
  def change
    rename_column :invoices, :overdue_at, :due_at
  end
end
