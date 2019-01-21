module Messenger
  class Base
    attr_reader :sender, :vendor_uid, :recipient_uid, :msg

    def conversation
      @_conversation ||= Conversation.where(wedding_uid: recipient_uid, vendor_uid: vendor_uid).first_or_create
    end

    def set_recipient uid
      @recipient_uid = uid
    end

    def inc_unread_messages uid
      Notification.inc_unread_messages(uid, conversation)
    end

    def errors
      msg.errors
    end
  end
end
