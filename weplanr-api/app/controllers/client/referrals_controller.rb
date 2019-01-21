class Client::ReferralsController < Client::BaseController
  include CRUD

  def create
    @_obj = obj_class.new(obj_params)
    if obj.save
      ReferralMailer.referral(current_user.wedding, obj).deliver_now
      render_common_response
    else
      render_422 obj
    end
  end

  private


  def obj_params
     @_obj_params ||=
      params[:data].require(:attributes).permit(*%i(
        referred_email
      ))
  end

  def obj_class
    current_user.wedding.referrals
  end

  def collection
    obj_class.where(status: 'accepted')
  end

  def serializer
    Client::ReferralSerializer
  end

end