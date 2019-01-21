class AuthToken < ApplicationRecord
  belongs_to :auth_tokenable, polymorphic: true

  scope :with_model, ->(model_class) { where(auth_tokenable_type: model_class.name) }

  def user
    auth_tokenable
  end
end
