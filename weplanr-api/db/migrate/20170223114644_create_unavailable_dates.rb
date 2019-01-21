class CreateUnavailableDates < ActiveRecord::Migration[5.0]
  def change
    create_table :unavailable_dates do |t|
      t.references :vendor, foreign_key: true
      t.date :date
      t.string :reason
      t.timestamps
    end
  end
end
