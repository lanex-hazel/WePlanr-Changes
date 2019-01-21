class Admin::QuoteItemSerializer < ActiveModel::Serializer
  attributes *%i(name description quantity cost)
end