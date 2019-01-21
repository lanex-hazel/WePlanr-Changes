class AddDefaultToVendorServices < ActiveRecord::Migration[5.0]
  def change
    change_column :vendors, :services, :string, array: true, default: []
  end
end
