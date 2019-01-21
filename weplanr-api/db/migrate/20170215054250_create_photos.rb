class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :name
      t.attachment :image
      t.references :imageable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
