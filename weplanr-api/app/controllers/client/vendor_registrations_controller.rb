class Client::VendorRegistrationsController < Client::BaseController
  include CRUD
  skip_before_action :authenticate!
  after_action :notify_on_reception_vendors, only: %i(create create_from_invite)

  def create_from_invite
    @_obj = User.new(email: existing_vendor.email, password: invite_params[:password], is_confirmed: true)
    obj.save && existing_vendor.update(invitation_code: params[:invite_token], user_id: obj.id) && invitation.destroy

    render_common_response
  end

  def verify_invite_token
    if existing_vendor
      render json: { email: existing_vendor.email }
    else
      render_404
    end
  end


  private

  def obj_class
    VendorBuilder
  end

  # def serializer
  #   Client::ProfileSerializer
  # end

  def obj_params
    params.require(:data).require(:attributes)
  end

  def existing_vendor
    @_vendor ||= invitation.inviteable
  end

  def invitation
    @_invitation ||= Invitation.find_by_token!(params[:invite_token])
  end

  def invite_params
    params[:data].require(:attributes).permit(:password)
  end

  def notify_on_reception_vendors
    if obj.vendor.primary_service&.name == 'Reception'
      AdminMailer.inform_new_reception_vendor(obj.vendor).deliver_now
    end
  end
end
