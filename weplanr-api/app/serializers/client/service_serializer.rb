class Client::ServiceSerializer < ActiveModel::Serializer
  attribute :name
  attribute :category do
    next unless category = object.category

    {
      id: category.id,
      name: category.name
    }
  end
end
