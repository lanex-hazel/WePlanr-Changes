class AddQuoteIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :quote, index: true
  end
end
