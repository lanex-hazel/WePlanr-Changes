class Admin::RewardTransactionSerializer < ActiveModel::Serializer
  attributes *%i(created_at gift_card_sent notified)

  attribute :email do
    object.wedding.primary_account.email
  end

  attribute :firstname do
    object.wedding.primary_account.firstname
  end

  attribute :lastname do
    object.wedding.primary_account.lastname
  end

  attribute :slug do
    object.wedding.primary_account.id
  end

  attribute :quote_amount do
    object.quote.total
  end
end
