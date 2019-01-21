class CreateBankCards < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_cards do |t|
      t.string :card_type
      t.string :full_name
      t.string :number
      t.string :expiry_month
      t.string :expiry_year
      t.string :external_id
      t.references :wedding, index: true
    end
  end
end
