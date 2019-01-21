class Client::FavoriteSerializer < ActiveModel::Serializer
  attributes *%i(
    business_name address_summary
    registered_street_address registered_suburb
    registered_state registered_country registered_post_code
    services public_contact_name
    profile_photo sample_photo slug
  )

  attribute :services do
    object.services.pluck(:name).flatten
  end

  def sample_photo
    unless object.cover_photo.present?
      photo = object.photos.first
      photo = photo.url if photo
      return photo
    end
    return object.cover_photo
  end

end
