class AddPrimaryServiceIdToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :primary_service_id, :integer
  end
end
