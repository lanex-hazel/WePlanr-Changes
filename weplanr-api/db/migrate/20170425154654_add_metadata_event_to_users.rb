class AddMetadataEventToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :metadata_event, :json, default: {}
  end
end
