class VendorBuilder
  REFERRAL_BONUS = 10
  REFERRAL_CREDIT = 40
  SIGNUP_FEE = 99

  attr_reader :params, :vendor, :user, :referral_code, :payment_error, :referral

  def initialize params
    @params = params
  end

  def save
    Vendor.transaction do
      create_user
      handle_referral if params[:promo_code].present?
      create_vendor

      if errors.blank? && valid? && make_payment
        VendorMailer.send_confirmation(user, vendor, @amount).deliver_now
        true
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  def valid?
    user.valid? && vendor.valid?
  end

  def errors
    raise payment_error if payment_error

    _errors = [user&.errors, vendor&.errors, referral_code&.errors, referral&.errors].flatten.compact
    _errors.find(&:any?) || User.new.errors
  end


  private


  def handle_referral
    @referral_code = ReferralCode.find_or_initialize_by(code: params[:promo_code])

    if referral_code.errors.blank?
      @referral = referral_owner.referrals.find_or_initialize_by(referred_email: params[:email])

      if referral_owner.is_a? Vendor
        referral_code.accumulated_credit += REFERRAL_CREDIT
        referral_code.current_credit += REFERRAL_CREDIT
      end

      referral_code.times_used += 1
      referral_code.save
      referral.status = 'accepted'
      referral.registered_date = Time.current
      referral.save
    end
  end

  def referral_owner
    owner = referral_code&.owner
  end

  def make_payment
    @amount = referral_code.present? ? SIGNUP_FEE - REFERRAL_BONUS : SIGNUP_FEE
    amount = @amount * 100 # convert to cents
    PaymentService.pay_vendor_registration(amount, vendor, card_params)
  end

  def create_user
    @user = UserService.create_user params
    UserService.bulk_favorite(params,user)
  end

  def create_vendor
    vendor_params = params.permit(*%i(
      business_name business_number address_summary
      registered_street_address registered_suburb
      registered_state registered_country registered_post_code
      email public_contact_name primary_phone secondary_phone
      website about
      registered_trading_name registered_for_gst insurance
      profile_photo
      primary_service_id
      firstname lastname
    ))

    services = params.permit(services: [])[:services]
    vendor_attr = vendor_params.merge(user: user, services: services)

    if vendor_params['primary_service_id'].to_i == Service.find_by_name('Reception').id
      vendor_attr['vendor_type'] = 'custom'
      vendor_attr['custom_vendor_fee_flat'] = 99
      vendor_attr['custom_vendor_fee_pcg'] = 0
    end

    @vendor = Vendor.new(vendor_attr)

    if tags = params[:tags]
      @vendor.tag_list = tags.join(',')
    end

    @vendor.save
    @vendor.settings.notify_msg_always.first_or_create
    @vendor
  end

  def card_params
    params.permit(*%i(number cvc exp_month exp_year))
  end

  def method_missing(method, *args, &block)
    if user.respond_to? method
      user.send method, *args, &block
    else
      vendor.send method, *args, &block
    end
  end

end
