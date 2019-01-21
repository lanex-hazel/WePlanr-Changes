class Client::WeddingSerializer < ActiveModel::Serializer
  attributes *%i(date location budget no_of_guests)

  attribute :name do
    object.name
  end

  attribute :email do
    object.email
  end

  attribute :profile_photo do
    user&.profile_photo&.url
  end

  attribute :online do
    user&.online?
  end

  attribute :last_active do
    object.last_active
  end

  def user
    @_user ||= object.users.first
  end


end
