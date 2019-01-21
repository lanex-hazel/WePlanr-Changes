class Admin::UserSerializer < ActiveModel::Serializer
  attributes *%i(
    firstname lastname email role phone
    created_at last_activity_at
  )

  attribute :avatar_photo do
    object.wedding.avatar_photo
  end

  attribute :confirmed do
    object.is_confirmed
  end

  attribute :partner do
    {
      firstname: partner&.firstname,
      lastname: partner&.lastname,
      email: partner&.email,
      role: partner&.role
    }
  end

  attribute :wedding_details do
    object.wedding.slice(*%w(location date budget no_of_guests))
  end

  def partner
    @_partner ||= object.partner
  end


end
