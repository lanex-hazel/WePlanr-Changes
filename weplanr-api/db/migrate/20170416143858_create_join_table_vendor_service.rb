class CreateJoinTableVendorService < ActiveRecord::Migration[5.0]
  def change
    create_join_table :vendors, :services do |t|
      t.index [:vendor_id, :service_id]
      # t.index [:service_id, :vendor_id]
    end
  end
end
