class Client::VendorSerializer < ActiveModel::Serializer
  attributes *%i(
    uid slug
    business_name business_number business_address address_summary
    suburb state
    registered_street_address registered_suburb
    registered_state registered_country registered_post_code
    public_contact_name primary_phone secondary_phone 
    pricing_and_packages
    social_channels website about
    profile_photo cover_photo photo_urls
    registered_trading_name email contact_name insurance registered_for_gst
    unavailable_dates address_lat address_lng primary_service_id
    firstname lastname
  )

  has_many :photos

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

  attribute :msg_notif_setting do
    setting = object.settings.msg_notif_setting.first
    setting ? setting.value : 'off'
  end

  def category
    object.primary_service
  end

  def primary_services
    @_primary_serv ||= category ? category.services.pluck(:name) : []
  end

  def unavailable_dates
    object.unavailable_dates.map do |date|
      date.attributes.slice(*%w(id date reason))
    end
  end

  def photo_urls _options={}
    cover = {}
    obj = []
    object.photos.each do |photo|
      coverPhoto =  photo.image_fingerprint == object.cover_photo_fingerprint
      hashValue = { id: photo.id, url: photo.url , cover_photo: coverPhoto}
      unless coverPhoto
        obj.push hashValue
      else
        cover = hashValue
      end
    end
    obj.unshift cover if cover.present?
    obj
  end

  def pricing_and_packages
    object.pricing_and_packages.map do |obj|
      obj.attributes.slice(*%w(id name price))
    end
  end
end
