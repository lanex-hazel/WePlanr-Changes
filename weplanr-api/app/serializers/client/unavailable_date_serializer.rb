class Client::UnavailableDateSerializer < ActiveModel::Serializer
  attributes :date, :reason
end
