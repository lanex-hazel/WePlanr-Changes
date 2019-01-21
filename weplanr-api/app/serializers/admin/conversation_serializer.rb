class Admin::ConversationSerializer < ActiveModel::Serializer
  attributes :uid, :created_at

  attribute :wedding do
    next {} unless wedding
    primary_account = wedding.primary_account

    {
      id: primary_account.id,
      email: primary_account.email,
      name: wedding.name,
      message_count: object.messages.where.not(user_id: nil).count
    }
  end

  attribute :vendor do
    next {} unless vendor

    {
      id: vendor.slug,
      email: vendor.email,
      business_name: vendor.business_name,
      message_count: object.messages.where(user_id: nil).count
    }
  end


  def wedding
    @_wedding ||= object.wedding
  end

  def vendor
    @_vendor ||= object.vendor
  end
end
