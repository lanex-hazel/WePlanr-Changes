class AddWeddingIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :wedding, index: true
  end
end
