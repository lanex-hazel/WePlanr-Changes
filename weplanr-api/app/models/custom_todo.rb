class CustomTodo < ApplicationRecord
  PENDING = 'pending'

  attr_accessor :todo_id, :type
  
  belongs_to :service
  belongs_to :wedding
  belongs_to :booking
  belongs_to :outside_vendor
  has_many :bookings

  validates :name, uniqueness: {scope: :wedding_id}, presence: true

  def restore
    self.status = PENDING
    save
  end

  def remove; destroy; end
end
