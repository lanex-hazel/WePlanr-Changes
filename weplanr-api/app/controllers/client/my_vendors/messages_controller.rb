class Client::MyVendors::MessagesController < Client::BaseController
  include ArraySerializer

  def index
    records = Conversation.where(vendor_uid: my_vendor.uid)
    records = records.search_weddings(params[:q]) if params[:q].present?

    if params[:filter].present?
      ids = records.select{ |r| r.type == params[:filter] }.pluck(:id)
      records = records.where(id: ids)
    end

    render json: serialize_array(records.order(updated_at: :desc), Client::VendorConversationSerializer)
  end

  def show
    messenger = Messenger::Vendor.new(my_vendor)
    messenger.set_recipient(params[:id])
    records = messenger.conversation.messages || []

    unless is_admin_logged_as_user?
      Messenger::Notification.clear_unread_messages(my_vendor.uid, messenger.conversation)
    end

    render json: serialize_array(records, Client::MessageSerializer)
  end

  def create
    messenger = Messenger::Vendor.new(my_vendor)
    obj = messenger.send(obj_params[:wedding_uid], obj_params[:content])

    if messenger.conversation.vendor_msg_count > 1 && wedding.settings.always_notify_on_msg?
      UserMailer.send_new_msg_notif(wedding, my_vendor, obj).deliver_now
    end

    render json: obj, serializer: Client::MessageSerializer, status: 201
  end

  def snippets
    records = Conversation.where(uid: params[:uids])
    render json: serialize_array(records, Client::VendorMessageSnippetSerializer)
  end


  private

  def wedding
    @_wedding ||= Wedding.find_by_uid(obj_params[:wedding_uid])
  end

  def my_vendor
    @_my_vendor ||= current_user.vendors.find_by_uid params[:my_vendor_id]
  end

  def obj_params
    @_obj_params ||= params.require(:data).require(:attributes).permit(*%i(wedding_uid content))
  end

end
