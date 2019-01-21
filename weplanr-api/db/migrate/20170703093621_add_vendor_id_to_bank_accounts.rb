class AddVendorIdToBankAccounts < ActiveRecord::Migration[5.0]
  def change
    add_reference :bank_accounts, :vendor, index: true
  end
end
