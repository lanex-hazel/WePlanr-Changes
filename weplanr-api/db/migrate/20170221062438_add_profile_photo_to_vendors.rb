class AddProfilePhotoToVendors < ActiveRecord::Migration[5.0]
  def up
    add_attachment :vendors, :profile_photo
  end

  def down
    remove_attachment :vendors, :profile_photo
  end
end
