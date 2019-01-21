module AuthTokenable
  extend ActiveSupport::Concern

  included do
    has_many :auth_tokens, as: :auth_tokenable, dependent: :destroy
  end


  def assign_auth_token
    self.auth_tokens.build token: generate_auth_token
  end

  def assign_auth_token!
    token = assign_auth_token
    token.save ? token : false
  end

  def auth_token
    self.auth_tokens.pluck(:token).last
  end


  private


  def generate_auth_token
    loop do
      key = SecureRandom.base64.tr('+/=', 'Qrt')
      break key unless AuthToken.exists?(token: key)
    end
  end

end
