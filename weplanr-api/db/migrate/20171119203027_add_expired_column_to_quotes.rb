class AddExpiredColumnToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :expired_at, :datetime
  end
end
