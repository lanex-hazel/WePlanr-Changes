class AlterServicesToBeArray < ActiveRecord::Migration[5.0]
  def up
    change_column :vendors, :services, :string, array: true, using: "(string_to_array(services, ';'))"
  end

  def down
    change_column :vendors, :services, :string
  end
end
