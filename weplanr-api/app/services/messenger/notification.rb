# NOTE
#   Vendor will listen to
#     /unread_messages/:vendor_uid/:type
#     /unread_messages/:vendor_uid/:type/:conversation_uid
#   User will listen to /unread_messages/:wedding_uid
#     /unread_messages/:wedding_uid/:type
#     /unread_messages/:wedding_uid/:type/:conversation_uid
#
module Messenger

  class Notification
    FIREBASE_URI = 'https://weplanr.firebaseio.com'
    FIREBASE_KEY = 'cT7kSRaLvW76VnWgEHipkkVm83Ujcx85sCsDhgBn'

    class << self
      def conn
        @@_connection ||= Firebase::Client.new(FIREBASE_URI, FIREBASE_KEY)
      end

      def get_unread_messages uid, conversation
        conn.get("unread_messages/#{uid}/#{conversation.type}/#{conversation.uid}").body
      end

      def inc_unread_messages uid, conversation
        return if Rails.env.test?

        unread_count = get_unread_messages(uid, conversation)
        new_count = unread_count.to_i + 1

        conn.set("unread_messages/#{uid}/#{conversation.type}/#{conversation.uid}", new_count)
      end

      def clear_unread_messages uid, conversation
        return if Rails.env.test?
        conn.delete("unread_messages/#{uid}/#{conversation.type}/#{conversation.uid}")
      end

      def transfer_to_booking uid, conversation
        return if Rails.env.test?

        inquiry_path = "unread_messages/#{uid}/inquiry/#{conversation.uid}"

        count = conn.get(inquiry_path).body
        conn.delete(inquiry_path)

        conn.set("unread_messages/#{uid}/booking/#{conversation.uid}", count) if count.is_a? Integer
      end

      def update_last_activity_time uid, time=Time.current
        return if Rails.env.test?
        conn.set("last_activity_time/#{uid}", time.iso8601)
      end

      def destroy_last_activity_time uid
        return if Rails.env.test?
        conn.delete("last_activity_time/#{uid}")
      end

    end
  end

end
