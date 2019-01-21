class AddUserReferencesToVendors < ActiveRecord::Migration[5.0]
  def change
    add_reference :vendors, :user, foreign_key: true
  end
end
