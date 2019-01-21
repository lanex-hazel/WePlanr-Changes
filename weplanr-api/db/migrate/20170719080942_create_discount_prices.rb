class CreateDiscountPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_prices do |t|
      t.string :description
      t.decimal :price, default: 0
    end
  end
end
