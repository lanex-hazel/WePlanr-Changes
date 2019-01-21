class User < ApplicationRecord
  extend FriendlyId
  include AuthTokenable
  has_secure_password

  friendly_id :uid, use: :finders

  belongs_to :wedding
  has_many :vendors
  has_many :favorites
  has_many :favorite_vendors, through: :favorites, source: :vendor

  scope :customers, ->{ where('wedding_id is not null') }
  scope :confirmed, ->{ where(is_confirmed: true) }
  scope :unconfirmed, ->{ where(is_confirmed: false) }
  scope :search_by_fullname, lambda {|customer_name| where("firstname ILIKE ? or lastname ILIKE ? or concat(firstname, ' ', lastname) ILIKE ?", "%#{customer_name}%", "%#{customer_name}%" , "%#{customer_name}%")}

  has_attached_file :profile_photo
  validates_attachment_content_type :profile_photo,
    content_type: /\Aimage\/.*\z/,
    adapter_options: { hash_digest: Digest::SHA256 }

  validates :email, uniqueness: true, email: true, if: :email?
  validates_presence_of :email, if: lambda {
      User.where(wedding_id: wedding_id).where.not(id: id).empty?
    }

  before_create :assign_uid
  before_create :set_confirmation
  before_save :downcase_email, if: Proc.new{ |obj| obj.email_changed? }

  def todos
    wedding ? wedding.todos : []
  end

  def bookings
    wedding ? wedding.booking_notlink_todo : []
  end

  def state_todos
    wedding ? wedding.todo_statuses : []
  end

  def pending_todos
    wedding ? wedding.pending_todos : []
  end

  def vendor
    vendors.first
  end

  def is_vendor?
    vendors.any?
  end

  def name
    firstname
  end

  def fullname
    [firstname, lastname].compact.join ' '
  end

  def name= new_value
    self.firstname = new_value
  end

  def partner
    wedding && wedding.users.where.not(id: id).first
  end

  def create_partner
    return partner if partner
    wedding.users.create(password_digest: password_digest, welcome_flg: false, is_confirmed: true)
  end

  def online?
    last_online_at = auth_tokens.maximum(:updated_at)
    last_online_at && last_online_at > 10.minutes.ago
  end

  def set_confirmation
    assign_uniq_token :confirmation_token
    self.confirmation_token_sent_at = Time.now
  end

  def set_temporary_password temporary_password
    assign_uniq_token :reset_password_token
    self.update_attributes(password: temporary_password, reset_password_token_sent_at: Time.now)
  end

  def set_welcome_flag
    self.update_attributes(welcome_flg: false)
  end

  def downcase_email
    self.email = email.downcase
  end

end
