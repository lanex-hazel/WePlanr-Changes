class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.string :external_id
      t.string :account_name
      t.string :bank_name
      t.string :holder_type
      t.string :account_type
      t.string :account_number
      t.string :routing_number
      t.string :country
      t.references :wedding, index: true
    end
  end
end
