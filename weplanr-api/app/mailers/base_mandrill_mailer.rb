require 'mandrill'

class BaseMandrillMailer < ActionMailer::Base
  DOMAIN = ENV['WEPLANR_DOMAIN'] || 'https://www.weplanr.com'
  CURRENT_YEAR = Time.current.year

  default(
    from: 'The WePlanr Team <hello@weplanr.com>',
    reply_to: 'hello@weplanr.com'
  )

  private

  def send_mail(email, subject, body)
    return true
    mail(to: email, subject: subject, body: body, content_type: "text/html")
  end

  def mandrill_template(template_name, attributes, options={})
    return '' if Rails.env.test?

    merge_vars = convert_to_array(attributes.merge({domain: DOMAIN, current_year: CURRENT_YEAR}))

    mandrill.templates.render(template_name, [], merge_vars)['html']
  end

  def mandrill_send template_name, opts
    return '' if Rails.env.test?

    mandrill.templates.master.call 'messages/send-template', {
      template_name: template_name,
      template_content: [],
      message: {
        subject: opts[:subject],
        to: opts[:to], # [ {email: 'foob@sourcepad.com', name: 'Foobar'} ],
        from_email: 'hello@weplanr.com',
        from_name: 'The WePlanr Team',
        global_merge_vars: convert_to_array(opts[:vars].merge({domain: DOMAIN, current_year: CURRENT_YEAR})),
        merge_language: 'handlebars',
      },
    }
  end

  def convert_to_array hash
    hash.map do |key, value|
      { name: key, content: value }
    end
  end

  def mandrill
    @@_mandrill ||= Mandrill::API.new(ENV['SMTP_PASSWORD'])
  end
end
