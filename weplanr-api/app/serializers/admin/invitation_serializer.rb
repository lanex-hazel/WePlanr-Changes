class Admin::InvitationSerializer < ActiveModel::Serializer
  attributes :created_at
  has_one :inviteable
end
