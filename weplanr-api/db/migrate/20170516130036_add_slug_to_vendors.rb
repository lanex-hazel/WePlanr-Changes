class AddSlugToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :slug, :string, index: true
  end
end
