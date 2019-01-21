class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.references :vendor, index: true
      t.string :referred_email
      t.string :status, default: 'pending'
      t.timestamps
    end
  end
end
