class Admin::ReferralSerializer < ActiveModel::Serializer
  attributes *%i(
    referred_email
    gift_card_sent notified
    registered_date created_at
  )

  attribute :referred_slug do
    object.referred_vendor&.slug
  end

  attribute :referrer do
    referrer = object.referrer

    if referrer.is_a? Wedding
      display_name = referrer.name
      user = referrer.primary_account
      slug = user.id
    elsif referrer.is_a? Vendor
      display_name = referrer.business_name
      user = referrer.user
      slug = referrer.slug
    end

    {
      email: user.email,
      firstname: user.firstname,
      lastname: user.lastname,
      display_name: display_name,
      slug: slug,
    }
  end

end
