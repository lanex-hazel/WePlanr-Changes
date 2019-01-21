module AuthTokenConcerns
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate!, only: :create
  end

  def create
    if obj && obj.authenticate(cred_params[:password]) && obj.assign_auth_token!
      if obj.class.name != "User" || obj.is_confirmed
        after_login if defined? after_login
        render json: obj.auth_tokens.last, serializer: Client::AuthTokenSerializer
      else
        render_401 'Please confirm your account'
      end
    else
      render_401 'Invalid credentials'
    end
  end

  def destroy
    @auth_token.destroy
    render json: {}, status: 204
  end


  private


  def obj
    @_obj ||= User.find_by_email(cred_params[:email].downcase)
  end

  def cred_params
    params.require(:credentials).permit(*%i(email password))
  end

end
