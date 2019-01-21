class AddAcceptedAtToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :accepted_at, :datetime
  end
end
