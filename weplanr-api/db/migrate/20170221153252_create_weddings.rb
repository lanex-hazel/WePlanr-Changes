class CreateWeddings < ActiveRecord::Migration[5.0]
  def change
    create_table :weddings do |t|
      t.integer :budget, default: 0
      t.string :location
      t.date :date
      t.references :user, index: true
      t.timestamps
    end
  end
end
