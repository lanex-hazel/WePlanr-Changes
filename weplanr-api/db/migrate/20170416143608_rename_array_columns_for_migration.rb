class RenameArrayColumnsForMigration < ActiveRecord::Migration[5.0]
  def change
    rename_column :vendors, :locations, :vendor_locations
    rename_column :vendors, :services, :vendor_services
  end
end
