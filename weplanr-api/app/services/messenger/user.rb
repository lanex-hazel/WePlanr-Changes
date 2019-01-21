module Messenger

  class User < Base

    def self.get_conversations user
      Conversation.where(wedding_uid: user.wedding.uid)
    end

    def self.latest_received_messages user
      conversations = get_conversations(user)
        .includes(:messages)
        .joins(:messages)
        .where(messages: {updated_at: 1.week.ago..Time.current, user_id: nil})

      conversations.map { |convo| convo.messages.last }
    end

    def initialize user, vendor_uid
      @sender = user
      @vendor_uid = vendor_uid
      set_recipient(sender.wedding.uid)
    end

    def send message
      @msg = conversation.messages.create(content: message, user: sender)
      VendorMailer.send_message_notif(sender, conversation).deliver_now if conversation.user_msg_count(sender) == 1

      if msg
        inc_unread_messages(vendor_uid)
        return msg
      else
        false
      end
    end
  end

end
