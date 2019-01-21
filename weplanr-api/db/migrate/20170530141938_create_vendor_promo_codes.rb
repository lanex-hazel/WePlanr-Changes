class CreateVendorPromoCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :vendor_promo_codes do |t|
      t.string :code
      t.integer :accumulated_credit, default: 0
      t.integer :times_used, default: 0
      t.timestamps

      t.index :code, unique: true
      t.references :vendor, index: true
    end
  end
end
