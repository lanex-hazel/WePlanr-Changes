class AddStripeIdToWeddings < ActiveRecord::Migration[5.0]
  def change
    add_column :weddings, :stripe_id, :string
  end
end
