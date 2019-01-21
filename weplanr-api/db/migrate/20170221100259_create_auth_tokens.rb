class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.string :token
      t.references :auth_tokenable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
