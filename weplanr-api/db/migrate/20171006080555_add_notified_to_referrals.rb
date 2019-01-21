class AddNotifiedToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :notified, :boolean, default: false
  end
end
