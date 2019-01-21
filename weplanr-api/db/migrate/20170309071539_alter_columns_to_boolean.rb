class AlterColumnsToBoolean < ActiveRecord::Migration[5.0]
  def change
    change_column :vendors, :insurance, :boolean, using: '(CASE insurance WHEN \'Y\' THEN \'t\'::boolean ELSE \'f\'::boolean END)'
    change_column :vendors, :registered_for_gst, :boolean, using: '(CASE registered_for_gst WHEN \'Y\' THEN \'t\'::boolean ELSE \'f\'::boolean END)'
  end
end
