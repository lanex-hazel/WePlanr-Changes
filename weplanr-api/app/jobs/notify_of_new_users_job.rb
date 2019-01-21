class NotifyOfNewUsersJob

  def self.perform
    notifs = AdminNotification.unsent.includes(:user)
    return if notifs.count == 0

    AdminMailer.inform_new_customers(notifs).deliver_now!

    notifs.update_all(sent_at: Time.current)
  end

end
