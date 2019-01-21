class Client::VendorProfileSerializer < Client::ProfileSerializer
  attribute :connected_to_stripe do
    object.vendors.any? &:stripe_account_id
  end

  attribute :internal_id do
    "VEN-#{object.id.to_s.rjust(6, '0')}"
  end
end
