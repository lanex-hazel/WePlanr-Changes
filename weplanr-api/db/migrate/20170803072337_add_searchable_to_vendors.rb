class AddSearchableToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :searchable, :boolean, default: true
  end
end
