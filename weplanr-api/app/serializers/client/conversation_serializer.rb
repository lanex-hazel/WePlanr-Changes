class Client::ConversationSerializer < ActiveModel::Serializer
  attributes :uid, :users_uid, :vendor_uid, :updated_at, :type

  attribute :online do
    vendor&.online?
  end

  attribute :business_name do
    vendor&.business_name
  end

  attribute :public_contact_name do
    vendor&.public_contact_name
  end

  attribute :profile_photo do
    vendor&.profile_photo
  end

  attribute :vendor_slug do
    vendor&.slug
  end

  attribute :vendor_service do
    if vendor
      (vendor.primary_service || vendor.services.first)&.name || 'Other'
    end
  end

  def vendor
    @_vendor ||= object.vendor
  end
end
