class FixTypoOnReleventVendorIds < ActiveRecord::Migration[5.0]
  def change
    rename_column :todos, :relevent_vendor_ids, :relevant_vendor_ids
  end
end
