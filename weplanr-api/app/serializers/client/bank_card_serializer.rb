class Client::BankCardSerializer < ActiveModel::Serializer
  attributes *%i(
    card_type
    full_name
    number
    expiry_month
    expiry_year
  )
end
