class RemoveForeignKeyConstraints < ActiveRecord::Migration[5.0]
  def change
    remove_reference :budgets, :wedding, index: true, foreign_key: true
    remove_reference :pricing_and_packages, :vendor, index: true, foreign_key: true
    remove_reference :unavailable_dates, :vendor, index: true, foreign_key: true
    remove_reference :users, :wedding, index: true, foreign_key: true
    remove_reference :vendors, :user, index: true, foreign_key: true

    add_reference :budgets, :wedding, index: true
    add_reference :pricing_and_packages, :vendor, index: true
    add_reference :unavailable_dates, :vendor, index: true
    add_reference :users, :wedding, index: true
    add_reference :vendors, :user, index: true
  end
end
