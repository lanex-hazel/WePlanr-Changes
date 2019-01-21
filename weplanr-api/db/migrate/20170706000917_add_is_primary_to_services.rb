class AddIsPrimaryToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :is_primary, :boolean, default: true
  end
end
