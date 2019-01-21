class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :internal_id, index: true
      t.string :name
      t.string :tags, array: true
      t.timestamps
    end
  end
end
