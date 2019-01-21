class SendWeeklyMessagesSummaryJob

  def self.perform
    weekly_notifs = Setting.includes(:owner).notify_msg_weekly.group_by(&:owner_type)

    weddings = weekly_notifs['Wedding'].map(&:owner)
    weddings.map do |wedding|
      user = wedding.primary_account
      msgs = Messenger::User.latest_received_messages(user)

      puts "Sending to user: #{user.email}"

      begin
        if msgs.count > 1
          UserMailer.send_weekly_messages_summary(user, msgs).deliver_now
        end
      rescue => e
        puts "Error: #{e}"
        next
      end
    end

    vendors = weekly_notifs['Vendor'].map(&:owner)
    vendors.map do |vendor|
      msgs = Messenger::Vendor.latest_received_messages(vendor)

      puts "Sending to vendor: #{vendor.slug}"

      begin
        if msgs.count > 1
          VendorMailer.send_weekly_messages_summary(vendor, msgs).deliver_now
        end
      rescue => e
        puts "Error: #{e}"
        next
      end
    end
  end

end
