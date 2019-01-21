class Client::MessageSnippetSerializer < Client::VendorMessageSnippetSerializer
  attribute :location do
    object.vendor&.address_summary
  end

  attribute :name do
    vendor.business_name
  end

  attribute :profile_photo do
    vendor.profile_photo.url
  end

  def vendor
    @_vendor ||= object.vendor
  end
end
