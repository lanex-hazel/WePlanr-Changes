class CreateJoinTableVendorLocation < ActiveRecord::Migration[5.0]
  def change
    create_join_table :vendors, :locations do |t|
      t.index [:vendor_id, :location_id]
      # t.index [:location_id, :vendor_id]
    end
  end
end
