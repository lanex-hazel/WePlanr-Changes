class Vendor < ApplicationRecord
  extend FriendlyId
  include PgSearch
  include ReferralConcern

  acts_as_taggable

  friendly_id :slug_candidates, use: [:slugged, :finders]
  def slug_candidates
    [
      :business_name,
      [:business_name, :sequence]
    ]
  end

  def sequence
    slug = normalize_friendly_id(business_name)
    Vendor.where("slug LIKE '#{slug}-%'").count + 2
  end

  def should_generate_new_friendly_id?
    slug.blank? || business_name_changed?
  end

  belongs_to :user
  belongs_to :primary_service, class_name: 'Category'
  has_many :settings, as: :owner, dependent: :destroy
  has_one :referral_code, as: :owner
  has_one :invitation, as: :inviteable
  has_many :unavailable_dates, dependent: :destroy
  has_many :other_locations, class_name: 'Location', dependent: :destroy
  has_many :photos, as: :imageable
  has_many :pricing_and_packages, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_many :referrals, as: :referrer
  has_many :invoices
  has_many :transactions, through: :quotes
  has_many :paid_transactions, as: :owner, class_name: 'Transaction'
  has_many :search_terms, through: :primary_service
  #has_many :extra_search_terms, through: :services, source: 'search_terms'
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :services

  has_attached_file :profile_photo #TODO resize
  has_attached_file :cover_photo
  validates_attachment_content_type :profile_photo,
    content_type: /\Aimage\/.*\z/,
    adapter_options: { hash_digest: Digest::SHA256 }
  validates_attachment_content_type :cover_photo,
    content_type: /\Aimage\/.*\z/,
    adapter_options: { hash_digest: Digest::SHA256 }


  scope :searchable, ->{ where(searchable: true) }
  scope :confirmed, ->{ where.not(user_id: nil) }
  scope :unconfirmed, ->{ where(user_id: nil) }
  scope :non_profit, ->{ where(vendor_type: 'non-profit') }
  scope :custom_fees, ->{ where(vendor_type: 'custom') }

  pg_search_scope :search_by_name,
    against: :business_name,
    using: {
      tsearch: {
        dictionary: 'english',
        any_word: true
      },
      trigram: {
        threshold: 0.2
      }
    }

  pg_search_scope :search_by_primary_service,
    associated_against: {
      primary_service: :name,
    },
    using: {
      tsearch: {
        dictionary: 'english',
        any_word: true
      },
      trigram: {
        threshold: 0.5
      }
    }

  pg_search_scope :search_by_services,
    associated_against: {
      primary_service: :name,
      services: :name,
    },
    using: {
      tsearch: {
        dictionary: 'english',
        any_word: true
      },
      trigram: {
        threshold: 0.5
      }
    }

  pg_search_scope :search_by_locations,
    associated_against: {
      locations: :name
    },
    using: {
      tsearch: {
        dictionary: 'english',
        any_word: true
      },
    }

  pg_search_scope :search_by_contact,
    against: :public_contact_name,
    using: {
      tsearch: {
        any_word: true
      },
      trigram: {
        threshold: 0.5
      }
    }

  pg_search_scope :general_search,
    against: {
      business_name: 'A',
    },
    associated_against: {
      primary_service: {name: 'B'},
      tags: {name: 'C'},
      services: {name: 'D'},
      #locations: {name: 'D'},
    },
    using: {
      tsearch: {
        # normalization: 2,
        dictionary: 'english',
        prefix: true,
        any_word: true
      },
      trigram: {
        threshold: 0.1,
        only: %w(business_name) # not working on associated_against
      }
    }

  scope :search_by_date, ->(date) do
    unavailable_ids = UnavailableDate.where(date: date).pluck(:vendor_id)
    where.not(id: unavailable_ids)
  end

  

  def self.search keyword
    search_results = Vendor.general_search(keyword)
    matched_with_location = Vendor.where(id: Location.includes(:vendors).where('lower(name) = lower(?)', keyword).pluck('vendors.id'))
    matched_with_custom_location = Vendor.where(id: Location.includes(:vendor).where('lower(name) = lower(?)', keyword).pluck('vendors.id'))

    force_order = search_results.pluck(:id) | matched_with_location.pluck(:id) | matched_with_custom_location.pluck(:id)
    query = where(id: force_order)

    if force_order.any?
      query.order("ARRAY_POSITION(array[#{force_order.join(',')}], vendors.id)")
    else
      query
    end
  end

  validate :validate_internal_id_uniqenuess
  def validate_internal_id_uniqenuess
    return if internal_id.blank?
    errors.add(:base, 'Vendor ID has already been taken') if Vendor.where(internal_id: internal_id).where.not(id: id).exists?
  end

  validate :validate_internal_id_format
  def validate_internal_id_format
    return if internal_id.blank?
    errors.add(:base, 'Vendor ID must be in valid format') unless /^\d+\.\d+$/ =~ internal_id
  end

  validate :validate_business_number
  def validate_business_number
    # TODO: validate only if changed?
    return if business_number.blank?

    sanitized = business_number.to_s.gsub(/\s/, '')
    errors.add(:business_number, 'must be valid') unless AbnLookup.validate(sanitized)
  end


  before_create :assign_uid
  before_save :assign_address_summary, if: Proc.new{ |obj| obj.suburb_changed? || obj.state_changed? }
  before_save :assign_public_contact_name, if: Proc.new{ |obj| obj.firstname_changed? || obj.lastname_changed? }
  before_save :assign_primary_service, if: :internal_id_changed?
  before_save :assign_internal_id, if: Proc.new{ |obj|
    obj.primary_service_id_changed? && !obj.internal_id_changed?
  }


  def services= str_array
    super str_array.first.is_a?(String) ? Service.where(name: str_array) : str_array
  end

  def locations= places
    super places.first.is_a?(String) ? Location.defaults.where(name: places) : places
  end

  def other_locations= locs
    other_locs =
      if locs.first.is_a?(String)
        locs.map{ |loc| Location.find_or_initialize_by(name: loc, vendor: self) }
      else
        locs
      end

    super(other_locs)
  end

  def insurance=  new_val
    write_attribute :insurance, convert_to_boolean(new_val)
  end

  def registered_for_gst= new_val
    write_attribute :registered_for_gst, convert_to_boolean(new_val)
  end

  def has_custom_vendor_fee?
    vendor_type != 'standard'
  end

  FLOAT_PATTERN = /\[([0-9]*\.?[0-9]+)\]/
  def parse_pricing_and_packages= str_array
    str_array.map do |str|
      name = str.remove(FLOAT_PATTERN)
      str.match(FLOAT_PATTERN) # $1 = price
      pricing_and_packages.new(name: name, price: $1.to_f)
    end
  end

  def online?
    user && user.online?
  end

  def referral_base_string
    business_name
  end

  def assign_primary_service
    return unless internal_id
    new_primary_service = Category.find_by_internal_id(internal_id.split('.')[0])
    self.primary_service = new_primary_service
  end

  def assign_internal_id
    vendor_no = primary_service.vendors_assigned_with

    loop do
      vendor_no += 1
      new_internal_id = "#{primary_service.id}.#{vendor_no}"

      next if Vendor.exists?(internal_id: new_internal_id)

      write_attribute :internal_id, new_internal_id
      break
    end

    # TODO: needs recalculation (eg. when a vendor changes primary_service)
    primary_service.vendors_assigned_with = vendor_no
    primary_service.save
  end

  def get_referral_code
    self.vendor_promo_code['code'] if self.vendor_promo_code.present?
  end

  def business_address
    [
      registered_street_address,
      registered_suburb,
      registered_state,
      registered_country,
      registered_post_code
    ].reject(&:blank?).join(', ')
  end

  def is_user_referral? user
    user.referrals.where(referred_email: self.email, status: 'accepted').first
  end

  def assign_address_summary
    write_attribute :address_summary, [suburb, state].reject(&:blank?).join(', ')
  end

  def assign_public_contact_name
    write_attribute :public_contact_name, [firstname, lastname].reject(&:blank?).join(' ')
  end

end
