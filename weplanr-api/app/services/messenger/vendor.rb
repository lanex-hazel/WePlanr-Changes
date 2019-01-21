module Messenger

  class Vendor < Base

    def self.get_conversations vendor
      Conversation.where(vendor_uid: vendor.uid)
    end

    def self.latest_received_messages vendor
      conversations = get_conversations(vendor)
        .includes(:messages)
        .joins(:messages)
        .where(messages: {updated_at: 1.week.ago..Time.current})
        .where.not(messages: {user_id: nil})

      conversations.map { |convo| convo.messages.last }
    end

    def initialize vendor
      @sender = vendor
      @vendor_uid = vendor.uid
    end

    def send receiver_uid, message
      _send receiver_uid, content: message
    end

    def send_quote receiver_uid, quote
      _send receiver_uid, quote: quote
    end

    def _send receiver_uid, params
      set_recipient(receiver_uid)
      @msg = conversation.messages.create(params)
      if conversation.vendor_msg_count == 1
        UserMailer.send_message_notif(conversation).deliver_now unless Rails.env.test?
      end

      if msg
        inc_unread_messages(recipient_uid)
        return msg
      else
        false
      end
    end
  end

end
