class Client::TodoSerializer < ActiveModel::Serializer
  attributes(*%i(
    id name status timing_min_month timing_max_month position
  ))
end
