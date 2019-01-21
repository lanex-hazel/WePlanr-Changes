class CreateDiscountItems < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_items do |t|
      t.references :quote, index: true
      t.integer :price
    end
  end
end
