class ChangeRelevantVendorIdsName < ActiveRecord::Migration[5.0]
  def change
    rename_column :todos, :relevant_vendor_ids, :relevant_service_ids
  end
end
