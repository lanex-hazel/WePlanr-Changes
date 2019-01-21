class RemoveTagsFromServices < ActiveRecord::Migration[5.0]
  def change
    remove_column :services, :tags, :string, array: true
  end
end
