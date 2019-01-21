class Setting < ApplicationRecord
  belongs_to :owner, polymorphic: true

  scope :msg_notif_setting, ->{ where(name: 'message_notification') }
  scope :notify_msg_always, ->{ msg_notif_setting.where(value: 'always') }
  scope :notify_msg_weekly, ->{ msg_notif_setting.where(value: 'weekly') }

  def self.always_notify_on_msg?
    notify_msg_always.exists?
  end
end
