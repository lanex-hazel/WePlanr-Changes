class AddChecksumToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :profile_photo_fingerprint, :string
    add_column :photos, :image_fingerprint, :string
  end
end
