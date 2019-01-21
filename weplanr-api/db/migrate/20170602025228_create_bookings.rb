class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.datetime :schedule
      t.string :client
      t.string :location
      t.string :details
      t.references :vendor, foreign_key: true
    end
  end
end
