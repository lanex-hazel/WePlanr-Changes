class CreateRewards < ActiveRecord::Migration[5.0]
  def change
    create_table :rewards do |t|
      t.references :wedding, index: true
      t.integer :credit, default: 0
      t.timestamps
    end
  end
end
