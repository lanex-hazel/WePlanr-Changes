class CreateBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :budgets do |t|
      t.integer :guide, default: 0
      t.integer :planned, default: 0
      t.integer :final, default: 0
      t.references :wedding, foreign_key: true
      t.timestamps
    end
  end
end
