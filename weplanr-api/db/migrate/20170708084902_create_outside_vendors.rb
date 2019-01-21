class CreateOutsideVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :outside_vendors do |t|
      t.string :business_name
      t.string :public_contact_name
      t.string :address_summary
      t.string :email
      t.string :website
      t.string :primary_phone
      t.references :wedding, index: true
    end
  end
end
