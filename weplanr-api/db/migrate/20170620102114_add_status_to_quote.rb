class AddStatusToQuote < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :status, :string, default: Quote::OFFERED
  end
end
