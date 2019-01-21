class Client::PhotoSerializer < ActiveModel::Serializer
  attributes *%i(name url)
end
