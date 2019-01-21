class Client::ReferralSerializer < ActiveModel::Serializer
  attributes *%i(referred_email status gift_card_sent)
end