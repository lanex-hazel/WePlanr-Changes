class ApplicationMailer < ActionMailer::Base
  default from:  "WePlanr <#{ENV['SPARKPOST_SENDER_EMAIL'] || 'support@weplanr.com'}>"

  layout 'mailer'
end
