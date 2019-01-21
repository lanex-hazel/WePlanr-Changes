class Admin::VendorSerializer < ActiveModel::Serializer
  attributes *%i(
    internal_id slug
    business_name business_number address_summary
    suburb state
    registered_street_address registered_suburb
    registered_state registered_country registered_post_code
    public_contact_name primary_phone secondary_phone
    social_channels website about vendor_type
    profile_photo cover_photo photo_urls
    registered_trading_name email contact_name insurance registered_for_gst invitation_code
    status unavailable_dates
    primary_service_id searchable anchor
    created_at custom_vendor_fee_pcg custom_vendor_fee_flat
    firstname lastname
    user_id
  )

  has_many :photos

  attribute :pricing_and_packages do
    object.pricing_and_packages.map do |package|
      Admin::PricingAndPackageSerializer.new(package).as_json
    end
  end

  attribute :confirmed do
    user.present?
  end

  attribute :last_activity_at do
    user&.last_activity_at
  end

  attribute :locations do
    object.locations.pluck(:name)
  end

  attribute :other_locations do
    object.other_locations.pluck(:name)
  end

  attribute :tags do
    object.tags.pluck(:name)
  end

  attribute :primary_services do
    object.services.pluck(:name) & primary_services - ['LGBTQ+', 'Same Sex Marriage']
  end

  attribute :secondary_services do
    object.services.pluck(:name) - primary_services - ['LGBTQ+', 'Same Sex Marriage']
  end

  def category
    object.primary_service
  end

  def primary_services
    @_primary_serv ||= category ? category.services.pluck(:name) : []
  end

  def status
    if user
      'Registered'
    elsif object.invitation
      'Invited'
    else
      'Not yet invited'
    end
  end

  def unavailable_dates
    object.unavailable_dates.map do |date|
      date.attributes.slice(*%w(id date reason))
    end
  end

  def photo_urls _options={}
    object.photos.map do |photo|
      hash = { id: photo.id, url: photo.url, cover_photo: photo.image_fingerprint == object.cover_photo_fingerprint}
      hash[:profile_picture] = true if photo.image_fingerprint == object.profile_photo_fingerprint
      hash
    end
  end

  def user
    @_user ||= object.user
  end

end
