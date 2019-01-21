class MakeRelevantVendorIdsArray < ActiveRecord::Migration[5.0]
  def change
    remove_column :todos, :relevant_vendor_ids, :stringd
    add_column :todos, :relevant_vendor_ids, :integer, array: true, default: []
  end
end
