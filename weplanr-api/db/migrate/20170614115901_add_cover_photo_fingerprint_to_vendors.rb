class AddCoverPhotoFingerprintToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :cover_photo_fingerprint, :string
  end
end
