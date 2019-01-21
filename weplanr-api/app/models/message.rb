class Message < ApplicationRecord
  belongs_to :conversation, touch: true
  belongs_to :user
  belongs_to :quote

  default_scope { order(created_at: :asc) }

  def vendor
    conversation.vendor
  end
end
