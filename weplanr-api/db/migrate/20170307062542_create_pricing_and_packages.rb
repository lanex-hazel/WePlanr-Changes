class CreatePricingAndPackages < ActiveRecord::Migration[5.0]
  def change
    remove_column :vendors, :pricing_and_packages, :string

    create_table :pricing_and_packages do |t|
      t.string :name
      t.float :price
      t.references :vendor, foreign_key: true
      t.timestamps
    end
  end
end
