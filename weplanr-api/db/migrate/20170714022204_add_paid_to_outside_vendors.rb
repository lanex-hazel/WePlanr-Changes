class AddPaidToOutsideVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :outside_vendors, :paid, :decimal, default: 0
    add_column(:outside_vendors, :created_at, :datetime)
    add_column(:outside_vendors, :updated_at, :datetime)
  end
end
