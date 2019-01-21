class Client::OutsideVendorSerializer < ActiveModel::Serializer
  attributes *%i(business_name public_contact_name address_summary
    email website primary_phone total_fee)
end