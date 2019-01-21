class Wedding < ApplicationRecord

  DELETED = 'deleted'

  has_many :users
  has_many :budgets
  has_many :default_todos, through: :budgets, source: :todo
  has_many :todo_statuses
  has_many :todos, through: :todo_statuses
  has_many :bank_accounts
  has_many :bank_cards
  has_many :quotes, dependent: :destroy
  has_many :bookings
  has_many :invoices
  has_many :transactions, as: :owner
  has_many :outside_vendors, dependent: :destroy
  has_many :custom_todos, dependent: :destroy
  has_many :todo_notes, dependent: :destroy
  has_one  :outstanding_todo
  has_one  :referral_code, as: :owner
  has_many :referrals, as: :referrer
  has_many :reward_transactions
  has_one  :reward
  has_many :settings, as: :owner, dependent: :destroy


  before_create :assign_uid
  include ReferralConcern # placed here to execute after assign_uid
  before_save :breakdown_budget, if: Proc.new { |obj| @_budget_changed }

  def primary_account
    users.order(created_at: :asc).first
  end

  def pending_todos
    Todo
      .joins(:service)
      .where.not(id: todo_statuses.not_pending.pluck(:todo_id))
      .order('timing_max_month DESC, timing_min_month DESC, todos.id ASC')
  end

  def booking_notlink_todo
    Booking.where.not(id: todo_statuses.pluck(:booking_id))
  end

  def booked
    Booking.where(id: todo_statuses.pluck(:booking_id).uniq)
  end

  def booked_outside
    OutsideVendor.where(id: todo_statuses.pluck(:outside_vendor_id).uniq)
  end

  def name
    users.pluck(:firstname).compact.sort.join ' & '
  end

  def avatar_photo
    user = users.find{ |u| u.profile_photo? } || self.users.first
    user.profile_photo.url
  end

  def email
    users.pluck(:email).compact.sort.join ' , '
  end

  def deleted?
    status.eql? DELETED
  end

  def last_active
    users.pluck(:last_activity_at).find { |date| date.present? ? date : nil }
  end

  def deactivate
    users.each{ |u| u.auth_tokens.map(&:destroy) } && update(status: DELETED)
  end

  def budget= val
    @_budget_changed = true
    write_attribute :budget, val
  end

  def user_uids
    users.pluck :uid
  end

  def update_outstanding_todo
    outstanding_todo.update(todo: pending_todos.first, views: 1)
  end

  def is_personalised?
    details = attributes.slice(*%w(location budget date))
    status = true
    if !users.count == 2
      status = false
    elsif !(details.select {|k,v| v.present? && v != 0}.length == 3)
      status = false
    end
    status
  end

  def update_users_metadata
    users.each do |user|
      user.metadata_event[:continue] = false
      user.save
    end
  end

  def is_referred_vendor? email
    referrals.where(referred_email: email, status: 'accepted').first
  end

  private


  def breakdown_budget
    # NOTE:
    #   created custom changed-checker bcoz this method
    #   is being called on Todo.new.save and causing
    #   Stack level too deep
    @_budget_changed = false

    # TODO
    # if Venue / Reception / Ceremony
    #   if reception 3.33
    #   elsif ceremony 1.67
    #
    # Question: on budget view. above will be displayed separately?
    Todo.all.each do |todo|
      current_state = todo_statuses.where(todo: todo).take
      guide = (budget * todo.budget_percent / 100.0).round
      obj = budgets.find_or_initialize_by(todo: todo)
      obj.guide = guide
      obj.planned = guide if todo.is_initial_plan && current_state&.status != 'removed'
      obj.save
    end
  end

end
