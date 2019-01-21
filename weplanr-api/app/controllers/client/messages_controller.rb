class Client::MessagesController < Client::BaseController
  include ArraySerializer

  after_action :log_inquiry, only: :create

  def index
    records = Conversation.where('wedding_uid = ?', current_user.wedding.uid)
    records = records.search_vendors(params[:q]) if params[:q].present?

    if params[:filter].present?
      ids = records.select{ |r| r.type == params[:filter] }.pluck(:id)
      records = records.where(id: ids)
    end

    render json: serialize_array(records.order(updated_at: :desc), Client::ConversationSerializer)
  end

  def show
    messenger = Messenger::User.new(current_user, params[:id])
    records = messenger.conversation.messages || []

    unless is_admin_logged_as_user?
      Messenger::Notification.clear_unread_messages(current_user.wedding.uid, messenger.conversation)
    end

    render json: serialize_array(records, Client::MessageSerializer)
  end

  def create
    messenger = Messenger::User.new(current_user, obj_params[:vendor_uid])
    obj = messenger.send obj_params[:content]

    if messenger.conversation.user_msg_count(current_user) > 1 && vendor.settings.always_notify_on_msg?
      VendorMailer.send_new_msg_notif(vendor, current_user.wedding, obj).deliver_now
    end

    render json: obj, serializer: Client::MessageSerializer, status: 201
  end

  def snippets
    records = Conversation.where(uid: params[:uids])
    render json: serialize_array(records, Client::MessageSnippetSerializer)
  end


  private

  def obj_params
    @_obj_params ||= params.require(:data).require(:attributes).permit(*%i(vendor_uid content))
  end

  def vendor
    @_vendor ||= Vendor.find_by_uid(obj_params[:vendor_uid])
  end

  def log_inquiry
    vendor.logs.inquiries.create(
      ip_address: request.remote_ip,
      user: current_user,
      vendor: vendor,
    ) unless vendor.logs.inquiries.where(user: current_user).exists?
  end

end
