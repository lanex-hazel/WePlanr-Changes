class Client::Organisr::TodoSerializer < ActiveModel::Serializer
  attributes(*%i(
    id name timing_min_month timing_max_month status
    planned actual paid position notes
  ))

  attribute :service do
    {
      #id: object.service_id,
      #name: object.service_name,
      order_rank: obj_service.order_rank,
    } if obj_service
  end

  attribute :category do
    category = obj_service&.category
    next nil unless category

    {
      id: category.id,
      name: category.name,
      order_rank: category.order_rank,
    }
  end

  attribute :vendor do
    serialize_vendor object.vendor
  end

  attribute :outside_vendor do
    serialize_vendor object.outside_vendor
  end


  def serialize_vendor booked_vendor
    booked_vendor.attributes.slice(*%w(
      id
      slug
      business_name
      public_contact_name
      address_summary
      email
      website
      primary_phone
    )) if booked_vendor
  end

  def obj_service
    @_service ||= object.service
  end
end
