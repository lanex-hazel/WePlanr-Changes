class AddReferencesToDiscountItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :discount_items, :referral, index: true
  end
end
