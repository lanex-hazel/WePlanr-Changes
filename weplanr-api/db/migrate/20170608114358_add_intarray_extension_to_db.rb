class AddIntarrayExtensionToDb < ActiveRecord::Migration[5.0]
  def up
    execute "create extension intarray;"
  end

  def down
    execute "drop extension intarray;"
  end
end
