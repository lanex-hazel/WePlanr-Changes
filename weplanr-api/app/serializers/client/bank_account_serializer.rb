class Client::BankAccountSerializer < ActiveModel::Serializer
  attributes *%i(
    account_name
    bank_name
    holder_type
    account_type
    account_number
    routing_number
    country
  )
end
