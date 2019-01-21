class AddIndexVendorsOnUid < ActiveRecord::Migration[5.0]
  def change
    add_index :vendors, :uid
  end
end
