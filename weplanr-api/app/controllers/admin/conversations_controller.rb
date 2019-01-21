class Admin::ConversationsController < Admin::BaseController
  include CRUD

  def show
    @_serializer = Admin::MessageSerializer
    super
  end

  private
  
  def obj_class
    Conversation
  end

  def collection
    obj_class.all.order('created_at DESC')
  end

  def serializer
    @_serializer ||= Admin::ConversationSerializer
  end
end
