class Admin::FeatureSerializer < ActiveModel::Serializer
  attributes *%i(name status updated_at)

end
