class RemoveInternalIdsFromServices < ActiveRecord::Migration[5.0]
  def change
    remove_column :services, :internal_id, :string
  end
end
