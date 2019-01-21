class UserMailer < BaseMandrillMailer

  def send_confirmation(user)
    return true
    subject = "Email Confirmation: Welcome to WePlanr!"
    
    merge_vars = {
      recipient: user.firstname,
      token: user.confirmation_token
    }
    body = mandrill_template("weplanr-user-confirmation", merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_reset_password(user,temporary_password,vendor=nil)
    subject = "Reset Password"

    if vendor.present?
      recipient = vendor.public_contact_name
    else
      recipient = user.firstname
    end
    merge_vars = {
      recipient: recipient,
      token: user.reset_password_token,
      temporary_password: temporary_password
    }
    body = mandrill_template("weplanr-user-password-reset", merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_downpayment_confirmation user, vendor, quote
    subject = 'Payment Confirmation'

    merge_vars = {
      recipient: user.firstname,
      down_payment: "%.2f" % (quote.total - quote.amount_due),
      due_payment: "%.2f" % quote.amount_due,
      due_date: quote.payment_due&.in_time_zone('Sydney').strftime('%d/%m/%Y'),
      vendor: vendor.business_name
    }
    body = mandrill_template('weplanr-customer-payment-confirmation', merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_full_payment_confirmation user, vendor, quote
    subject = 'Payment Confirmation'

    merge_vars = {
      recipient: user.firstname,
      paid_amount: "%.2f" % (quote.transactions.last.amount),
      total_amount: "%.2f" % quote.total,
      vendor: vendor.business_name
    }
    body = mandrill_template('weplanr-customer-full-payment-confirmation', merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_card_declined user
    subject = 'Payment Declined'

    merge_vars = {
      recipient: user.firstname,
    }
    body = mandrill_template('weplanr-payment-declined', merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_welcome_email user
    subject = "Congratulations on your engagement #{user.firstname}!"

    merge_vars = {
      recipient: user.firstname
    }
    body = mandrill_template('weplanr-user-welcome-email', merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_message_notif obj
    subject = "Message Notification"
    user = obj.users.first
    vendor = obj.vendor

    merge_vars = {
      recipient: user.firstname,
      sender: vendor.firstname,
      business_name: vendor.business_name,
      state: 'user',
      uid: obj.uid
    }
    body = mandrill_template('weplanr-message-notification', merge_vars)

    send_mail(user.email, subject, body)
  end

  def send_new_msg_notif(wedding, vendor, msg)
    to = wedding.users.pluck(:email).compact.join(',')
    subject = "You have a message from #{vendor.business_name}"

    merge_vars = {
      recipient: wedding.name,
      sent_at: msg.created_at.in_time_zone('Sydney').strftime('%-d %b %Y %I:%M %P'),
      snippet: msg.content ? msg.content.truncate(103) : 'Hi, I sent you a new quote.',
      chat_uid: msg.conversation.uid,
      state: 'user',
    }
    body = mandrill_template('weplanr-new-message-notification', merge_vars)


    send_mail(to, subject, body)
  end

  def send_weekly_messages_summary user, messages
    wedding = user.wedding

    mandrill_send 'weplanr-weekly-messages-summary',
      subject: "Hey #{wedding.name}, here’s a few things you may have missed this week!",
      to: wedding.users.map { |u|
        { email: u.email, name: u.fullname } if u.email
      }.compact,
      vars: {
        items: messages.map do |msg|
          {
            from: msg.vendor.business_name,
            sent_at: msg.created_at.strftime('%-d %b %Y %I:%M %P'),
            link: "#{DOMAIN}/user/messages?chat=#{msg.conversation.uid}"
          }
        end
      }
  end
end
