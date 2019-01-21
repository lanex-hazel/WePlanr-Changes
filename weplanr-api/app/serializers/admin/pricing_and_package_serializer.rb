class Admin::PricingAndPackageSerializer < ActiveModel::Serializer
  attributes *%i(name price created_at updated_at)
end
