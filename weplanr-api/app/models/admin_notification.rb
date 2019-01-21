class AdminNotification < ApplicationRecord
  belongs_to :user

  scope :unsent, ->{ where(sent_at: nil) }
end
