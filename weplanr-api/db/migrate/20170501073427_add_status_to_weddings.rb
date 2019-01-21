class AddStatusToWeddings < ActiveRecord::Migration[5.0]
  def change
    add_column :weddings, :status, :string, default: 'active'
  end
end
