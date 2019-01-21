class AddWelcomeFlgToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :welcome_flg, :boolean, default: true
  end
end
