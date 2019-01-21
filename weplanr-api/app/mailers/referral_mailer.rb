class ReferralMailer < BaseMandrillMailer

  def referral(from, to)
    if from.is_a? Vendor
      referrer = (from.public_contact_name || '').split(' ')[0]
      subject = "#{referrer} from #{from.business_name} thinks WePlanr is awesome, and you might too!"
      template = "weplanr-vendor-referral"
    else
      referrer = from.name
      subject = "#{referrer} are getting married and would love to speak to you!"
      template = "weplanr-user-referral"
    end
    merge_vars = {
      referrer: referrer,
      code: from.referral_code.code
    }

    body = mandrill_template(template, merge_vars)

    send_mail(to.referred_email, subject, body)
  end

end
