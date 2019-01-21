class CreateViews < ActiveRecord::Migration[5.0]
  def change
    create_table :views do |t|
      t.string :ip_address
      t.references :user
      t.references :vendor, index: true
      t.datetime :created_at, null: false
    end
  end
end
