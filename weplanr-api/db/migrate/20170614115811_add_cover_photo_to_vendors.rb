class AddCoverPhotoToVendors < ActiveRecord::Migration[5.0]
  def up
    add_attachment :vendors, :cover_photo
  end

  def down
    remove_attachment :vendors, :cover_photo
  end
end
