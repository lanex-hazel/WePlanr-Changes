class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.string :token, index: true
      t.references :inviteable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
