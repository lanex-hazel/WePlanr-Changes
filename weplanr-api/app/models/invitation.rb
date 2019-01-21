class Invitation < ApplicationRecord
  belongs_to :inviteable, polymorphic: true

  before_create :assign_token

  def assign_token
    assign_uniq_token :token
  end

end
