class Booking < ApplicationRecord
  belongs_to :vendor, touch: true
  belongs_to :wedding
  validates :schedule, presence: true
  # validates :schedule, uniqueness: {scope: :vendor_id}, presence: true
  has_many :todo_statuses
  has_many :todos, through: :todo_statuses
  has_many :custom_todos
  belongs_to :quote
  belongs_to :custom_todo

  after_create :log_booking, if: Proc.new { |booking| booking.quote.present? }

  def eventDay
    schedule.strftime("%F")
  end

  def eventDate
    schedule.strftime("%d.%m.%Y")
  end

  def schedule_time
    schedule.to_s(:time)
  end

  def schedule_time_12hr
    schedule.strftime("%I:%M %P")
  end

  def self.by_year date
    where('extract(year from schedule) = ?', date).order("schedule ASC").group_by(&:eventDate).map do |event_date, list|
      {
        event_date: event_date,
        bookings: list.count
      }
    end
  end

  def self.by_month date
    start = date.at_beginning_of_month
    finish = date.at_end_of_month
    where("schedule >= ? AND schedule <= ?", start - 7, finish + 7).order("schedule ASC")
  end

  def self.by_day date
    start = date.at_beginning_of_day
    finish = date.at_end_of_day
    where("schedule >= ? AND schedule <= ?", start, finish).order("schedule ASC")
  end

  private

   def log_booking
    vendor.logs.bookings.create(
      user: wedding.users.first,
      vendor: vendor,
    )
  end


end
