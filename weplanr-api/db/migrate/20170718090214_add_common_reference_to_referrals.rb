class AddCommonReferenceToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_reference :referrals, :referrer, polymorphic: true, index: true
  end
end
