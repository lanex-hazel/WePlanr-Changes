class AddMetadataToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :metadata, :json, default: {}
  end
end
