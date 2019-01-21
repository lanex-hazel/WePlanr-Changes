include ArraySerializer
class Client::UnavailableDateDetailSerializer < ActiveModel::Serializer
  attributes *%i(dates details)

  def dates
    object.map(&:date)
  end

  def details
    object.map { |obj| serialize_obj(obj, Client::UnavailableDateSerializer) }
  end

end