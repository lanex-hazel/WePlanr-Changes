class Admin::MessageSerializer < Admin::ConversationSerializer
  attribute :messages do
    object.messages.order('created_at DESC').map do |msg|
      {
        created_at: msg.created_at,
        email: emails[msg.user_id.to_s],
        content: msg.content,
        receiver: receiver(msg)
      }
    end
  end

  def emails
    @_emails ||=
      begin
        result = { '' => vendor.email }

        wedding.users.each do |user|
          result[user.id.to_s] = user.email
        end

        result
      end
  end

  def receiver msg
    if msg.user.is_a?(User)
      vendor.email
    else
      wedding.email
    end
  end

end
