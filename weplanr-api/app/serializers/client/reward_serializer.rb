class Client::RewardSerializer < ActiveModel::Serializer
  attributes *%i(credit)

  attribute :no_of_transactions do
    object.wedding.reward_transactions.count
  end
end
