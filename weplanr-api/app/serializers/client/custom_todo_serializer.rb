class Client::CustomTodoSerializer < ActiveModel::Serializer
  attributes *%i(id planned is_customVendor is_booked is_removed)

  attribute :guide do
    0
  end

  attribute :actual do
    if is_customVendor
      object.outside_vendor.total_fee.ceil
    elsif is_booked
      object.booking.quote.total.ceil
    else
      0
    end
  end

  attribute :paid do
    if is_customVendor
      object.outside_vendor.paid.ceil
    elsif is_booked
      object.booking.quote.total_paid.ceil
    else
      0
    end
  end

  def is_customVendor
    return false unless object.outside_vendor.present?
    object.outside_vendor
  end

  def is_booked
    return false unless object.booking.present?
    object.booking
  end

  def is_removed
    false
  end

  attribute :todo do
    {
      id: object.id,
      service: object.name
    }
  end

end