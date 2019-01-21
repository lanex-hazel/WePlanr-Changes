class Client::AuthTokensController < Client::BaseController
  include AuthTokenConcerns
   skip_before_action :authenticate!, only: [:confirm]

  def after_login
    @current_user = obj
    update_last_activity_record
    obj.wedding.outstanding_todo.add_view_count if !obj.is_vendor? && obj.wedding.outstanding_todo
  end


  def obj
    @_obj ||= begin
      user = User.find_by_email(cred_params[:email].downcase)
      user if user && (user.wedding.blank? || !user.wedding.deleted?)
    end
  end

  def confirm
    obj = User.find_by(confirmation_token: params[:confirmation_token])
    if !obj.present?
      render_401 "Invalid token."
    elsif obj.is_confirmed
      render_401 "Email is already confirmed. Please login your account."
    else
      obj.update_attributes(confirmation_token: nil, is_confirmed: true)
      obj.assign_auth_token!
      UserMailer.send_welcome_email(obj).deliver_now unless obj.is_vendor?

      render json: obj, serializer: (obj.is_vendor? ? Client::VendorProfileSerializer : Client::ProfileSerializer)
    end
  end
end
