class AddInternalIdToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :internal_id, :string
    add_index :categories, :internal_id, unique: true
  end
end
