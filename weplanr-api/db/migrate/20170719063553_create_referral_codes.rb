class CreateReferralCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :referral_codes do |t|
      t.string :code
      t.integer :accumulated_credit, default: 0
      t.integer :current_credit, default: 0
      t.integer :times_used, default: 0
      t.references :owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
