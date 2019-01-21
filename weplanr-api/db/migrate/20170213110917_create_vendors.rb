class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :vendors do |t|
      t.string :business_name
      t.string :business_number
      t.string :personal_name
      t.string :email
      t.string :locations, array: true
      t.string :invitation_code
      t.string :website
      t.json :social_channels
      t.string :phone
      t.string :insurance

      t.timestamps
    end
  end
end
