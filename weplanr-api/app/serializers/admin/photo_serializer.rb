class Admin::PhotoSerializer < ActiveModel::Serializer
  attributes *%i(name url)
end
