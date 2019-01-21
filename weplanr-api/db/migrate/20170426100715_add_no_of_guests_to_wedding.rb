class AddNoOfGuestsToWedding < ActiveRecord::Migration[5.0]
  def change
    add_column :weddings, :no_of_guests, :integer
  end
end
