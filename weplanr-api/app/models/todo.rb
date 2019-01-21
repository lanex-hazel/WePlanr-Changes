class Todo < ApplicationRecord
  belongs_to :service
  belongs_to :booking
  has_many :todo_statuses

  # TODO hack for organisr api when no todo to display but the defaults
  def status
    TodoStatus::PENDING
  end
end
