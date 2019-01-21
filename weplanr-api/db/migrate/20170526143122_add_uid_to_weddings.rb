class AddUidToWeddings < ActiveRecord::Migration[5.0]
  def change
    add_column :weddings, :uid, :string
  end
end
