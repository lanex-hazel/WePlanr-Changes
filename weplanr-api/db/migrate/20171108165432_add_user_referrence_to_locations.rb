class AddUserReferrenceToLocations < ActiveRecord::Migration[5.0]
  def change
    add_reference :locations, :vendor, index: true
  end
end
