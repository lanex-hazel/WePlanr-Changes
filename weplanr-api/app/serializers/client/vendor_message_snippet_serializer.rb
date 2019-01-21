class Client::VendorMessageSnippetSerializer < ActiveModel::Serializer
  attributes :uid

  attribute :snippet do
    object.messages.last.content
  end

  attribute :name do
    object.wedding.name
  end

  attribute :profile_photo do
    photo = users[0].profile_photo.url
    if photo.blank? && users.count > 1
      users[1].profile_photo.url
    else
      photo
    end
  end

  def users
    @_users ||= object.users
  end

end
