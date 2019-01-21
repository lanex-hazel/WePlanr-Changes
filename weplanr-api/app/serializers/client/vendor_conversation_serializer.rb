class Client::VendorConversationSerializer < ActiveModel::Serializer
  attributes :uid, :vendor_uid, :updated_at, :type

  attribute :user do
    next {} unless user

    {
      firstname: user.firstname,
      lastname: user.lastname,
      wedding: {
        uid: user.wedding.uid,
        id: user.wedding.id,
        name: user.wedding.name,
        date: user.wedding.date,
        location: user.wedding.location
      }
    }
  end

  attribute :profile_photo do
    user&.profile_photo&.url
  end

  attribute :online do
    user&.online?
  end


  def user
    @_user ||= object.users.first
  end
end
