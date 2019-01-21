class Client::UsersController < Client::BaseController
  include Users
  skip_before_action :authenticate!
  before_action :check_token, only: [:verify_reset_token]

  def forgot_password
    obj = User.find_by_email(obj_params[:email].downcase)
    unless obj.present?
      render_401 "Email address doesn't match any account"
    else
      temp = SecureRandom.base64(6)
      if obj.set_temporary_password temp
        UserMailer.send_reset_password(obj,temp,vendor).deliver_now
      else
        render_401 "Failed to reset password"
      end
    end
  end

  def reset_password
    if !user.present?
      render_401 "Invalid credentials"
    elsif !(user && user.authenticate(obj_params[:password]) && user.reset_password_token == obj_params[:token])
      render_401 "Invalid temporary password"
    else
      user.update_attributes(password: obj_params[:new_password], reset_password_token: nil)
    end
  end

  def verify_reset_token
    if @obj.present?
      render json: {success: true}
    else
      render_401 "Invalid token"
    end
  end

  def bookings
    render json: {collection: Users::Booking.new(current_user.wedding).list}
  end

  private

  def obj_params
    params.permit(*%i(email password token new_password))
  end

  def check_token
    @obj = User.where(reset_password_token: obj_params[:token])
  end

  def user
    @_obj ||= User.find_by_email(obj_params[:email].downcase)
  end

  def vendor
    @_obj ||= Vendor.find_by_user_id(user.id)
  end
end