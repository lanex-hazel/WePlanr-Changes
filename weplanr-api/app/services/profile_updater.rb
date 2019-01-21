class ProfileUpdater

  attr_reader :user, :params, :partner, :wedding

  def initialize user
    @user = user
    @partner = user.partner
    @wedding = user.wedding
  end

  def update params
    @params = params

    user.transaction do
      user.attributes = user_params
      user.password = user_params[:password] if user_params[:password].present?

      profile_photo = params.delete(:profile_photo)
      update_profile_photo(profile_photo) if profile_photo

      wedding.attributes = params[:wedding_details] if params[:wedding_details]
      update_partner

      if params[:msg_notif_setting]
        msg_notif_setting = wedding.settings.msg_notif_setting.first_or_initialize
        msg_notif_setting.update(value: params[:msg_notif_setting])
      end

      user.save && (wedding&.save || true) && (partner ? partner.save : true)
    end
  end

  def update_partner
    if partner.blank? && partner_params
      @partner = user.create_partner
    end

    partner.attributes = partner_params if partner_params
  end

  def update_profile_photo profile_photo
    to_update = user.wedding&.users&.find{ |u| u.profile_photo? } || user
    to_update.update profile_photo: profile_photo
  end

  def user_params
    params.except(:partner, :wedding_details, :msg_notif_setting)
  end

  def partner_params
    params[:partner]
  end

  def valid?
    user.valid? && (partner.blank? or partner.valid?)
  end

  def errors
    _errors = [user&.errors, wedding&.errors, partner&.errors].flatten.compact
    _errors.find(&:any?) || User.new.errors
  end


  def method_missing(method, *args, &block)
    user.send method, *args, &block
  end

end
