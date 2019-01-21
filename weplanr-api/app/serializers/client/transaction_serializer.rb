class Client::TransactionSerializer < ActiveModel::Serializer
  attributes *%i(amount status description created_at)

  attribute :owner do
    object.owner.name
  end
end
