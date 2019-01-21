class Admin::AuthTokensController < Admin::BaseController
  include AuthTokenConcerns


  def login_as
    user = User.find(params[:id])

    obj = user.assign_auth_token
    obj.token = obj.token.sub(obj.token[0,5], '4DM1N')
    obj.save

    render json: {
      data: { token: obj.token }
    }
  end


  private


  def obj
    @_obj ||= Admin.find_by_username(cred_params[:username])
  end

  def cred_params
    params.require(:credentials).permit(*%i(username password))
  end

end
