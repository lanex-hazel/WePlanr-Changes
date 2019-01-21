class VendorMailer < BaseMandrillMailer

  def invite vendor
    subject = "Ready, Set, Go! Welcome to your WePlanr Account!"

    merge_vars = {
      recipient: vendor.firstname,
      invitation_token: vendor.invitation.token
    }
    body = mandrill_template('weplanr-vendor-invite', merge_vars)

    send_mail(vendor.email, subject, body)
  end

  def send_confirmation(user,vendor,amount)
    subject = "Email Confirmation: Welcome to WePlanr!"

    merge_vars = {
      recipient: vendor.firstname,
      payment: "%.2f" % amount,
      token: user.confirmation_token
    }
    body = mandrill_template('weplanr-vendor-confirmation', merge_vars)

    send_mail(user.email, subject, body)
  end


  def send_booking_notif(vendor, quote, transaction)
    payment_confirmation(vendor, quote, transaction, {
      template: 'weplanr-vendor-booking-notification',
      subject: "You've received payment from #{quote.wedding.name}."
    })
  end

  def payment_confirmation(vendor, quote, transaction, opts={})
    wedding_name = quote.wedding.name
    template = opts.fetch(:template, 'weplanr-vendor-payment-confirmation')
    subject = opts.fetch(:subject, "You've received full payment from #{wedding_name}.")

    merge_vars = {
      recipient: vendor.firstname,
      wedding_name: wedding_name,
      booking_amount: "%.2f" % transaction.amount,
      total_amount: "%.2f" % quote.amount_due,
      due_at: quote.payment_due&.in_time_zone('Sydney').strftime('%-d/%m/%Y'),
    }
    body = mandrill_template(template, merge_vars)

    send_mail(vendor.email, subject, body)
  end

  def send_message_notif user, obj
    subject = "Message Notification"
    vendor = obj.vendor

    merge_vars = {
      recipient: vendor.firstname,
      sender: user.firstname,
      state: 'vendor',
      uid: obj.uid
    }
    body = mandrill_template('weplanr-message-notification', merge_vars)

    send_mail(vendor.email, subject, body)
  end

  def send_new_msg_notif(vendor, wedding, msg)
    subject = "You have a message from #{wedding.name}"

    merge_vars = {
      recipient: vendor.firstname,
      sent_at: msg.created_at.in_time_zone('Sydney').strftime('%-d %b %Y %I:%M %P'),
      snippet: msg.content.truncate(103),
      chat_uid: msg.conversation.uid,
      state: 'vendor',
    }
    body = mandrill_template('weplanr-new-message-notification', merge_vars)

    send_mail(vendor.email, subject, body)
  end

  def send_weekly_messages_summary vendor, messages
    mandrill_send 'weplanr-weekly-messages-summary',
      subject: "Hey #{vendor.firstname}, here’s a few things you may have missed this week!",
      to: [{ email: vendor.email, name: vendor.firstname }],
      vars: {
        items: messages.map do |msg|
          {
            from: msg.user.fullname,
            sent_at: msg.created_at.strftime('%-d %b %Y %I:%M %P'),
            link: "#{DOMAIN}/vendor/messages?chat=#{msg.conversation.uid}"
          }
        end
      }
  end


  #def send_invoice vendor, invoice
    #quote = invoice.quote
    #wedding = wedding
    #total = quote.total
    #amount_due = quote.amount_due

    #mandrill_send 'weplanr-vendor-invoice',
      #subject: 'Tax Invoice Copy',
      #to: wedding.users.map{ |user|
        #{ email: user.email, name: user.fullname }
      #}.push({ email: vendor.email, name: vendor.contact_name }),
      #vars: {
        #to: wedding.name,
        #from: vendor.business_name,
        #abn: vendor.business_number,
        #issued_date: quote.accepted_at&.strftime('%-d %B %Y'),
        #payment_due: quote.payment_due&.strftime('%-d %B %Y'),
        #delivery_date: quote.delivery_date&.strftime('%-d %B %Y'),
        #items:  quote.quote_items.map { |item|
          #result = item.attributes.slice(*%w(name description cost))
          #result['cost'] = "%.2f" % result['cost']
          #result
        #},
        #subtotal: "%.2f" % quote.subtotal,
        #total_gst: "%.2f" % quote.total_gst,
        #total: "%.2f" % total,
        #less_amount_paid: "%.2f" % (total - amount_due),
        #amount_due: "%.2f" % amount_due,
      #}
  #end

end
