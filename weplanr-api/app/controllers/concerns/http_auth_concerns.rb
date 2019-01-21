
module HttpAuthConcerns
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :authenticate!
  end

  def current_user
    @current_user or (authenticate_token && @current_user)
  end

  def authenticate!
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    @auth_token = AuthToken.with_model(model_class).find_by_token(http_token)

    if @auth_token
      @current_user = @auth_token.user
      update_last_activity_record
      @current_user
    else
      false
    end
  end

  def http_token
    if respond_to?(:custom_auth_token_getter) && custom_auth_token_getter
      custom_auth_token_getter
    else
      token = nil
      authenticate_with_http_token{ |val, _| token = val }
      return token
    end
  end

  def render_unauthorized(realm = 'Application')
    self.headers['WWW-Authenticate'] = %(Token realm="#{realm.delete('"')}")
    render json: {error: 'Bad credentials'}, status: 401
  end

  def update_last_activity_record
    return if is_admin_logged_as_user?

    current_time = Time.current
    prev_activity_at = @current_user.last_activity_at

    @auth_token&.touch
    @current_user.update_column(:last_activity_at, current_time)

    return unless model_class == User
    entity = @current_user.is_vendor? ? @current_user.vendors.first : @current_user.wedding

    if params[:controller] == 'client/auth_tokens' && params[:action] == 'destroy'
      Messenger::Notification.destroy_last_activity_time(entity.uid)
    elsif prev_activity_at.nil? || prev_activity_at < 10.minutes.ago || params[:controller] == 'client/auth_tokens'
      Messenger::Notification.update_last_activity_time(entity.uid, current_time)
    end
  end

  def is_admin_logged_as_user?
    @auth_token && @auth_token.token[0,5] == '4DM1N'
  end

  def model_class
    User
  end

end