class AdminMailer < BaseMandrillMailer

  def inform_new_reception_vendor vendor
    subject = "New Reception Vendor: #{vendor.business_name}"

    merge_vars = {
      email: vendor.email,
      business_name: vendor.business_name,
      public_contact_name: vendor.public_contact_name,
    }
    body = mandrill_template('weplanr-inform-new-reception-vendor', merge_vars)

    send_mail('hello@weplanr.com, abbya.sp.wp@gmail.com', subject, body)
  end

  def inform_new_customers notifs
    return true
    mandrill_send 'weplanr-new-users-update',
      subject: 'New WePlanr User',
      to: [
        { email: 'erika@weplanr.com', name: 'Erika' },
        { email: 'alice@weplanr.com', name: 'Alice' },
      ],
      vars: {
        items: notifs.map { |notif|
          user = notif.user
          result = user.attributes.slice(*%w(firstname lastname email phone))
          sydney_signup_at = user.created_at.in_time_zone('Sydney')

          result['signup_date'] = sydney_signup_at.strftime('%-d %b %Y')
          result['signup_time'] = sydney_signup_at.strftime('%I:%M %p')
          result
        },
      }
  end

end
