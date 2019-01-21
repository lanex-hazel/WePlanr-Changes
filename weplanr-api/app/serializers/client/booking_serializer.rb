class Client::BookingSerializer < ActiveModel::Serializer
  attributes *%i(
    schedule
    schedule_time
    schedule_time_12hr
    client
    location
    details
    system_booking
  )

  attribute :client do
    system_booking ? object.wedding.name : object.client
  end

  attribute :location do
    system_booking ? object.wedding.location : object.location
  end

  def system_booking
    object.wedding.present?
  end
end
