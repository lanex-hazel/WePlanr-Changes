class Conversation < ApplicationRecord
  include PgSearch

  has_many :messages, dependent: :destroy

  before_create :assign_uid

  pg_search_scope :search_by_messages,
    associated_against: {
      messages: :content
    },
    using: {
      tsearch: {
        dictionary: 'english',
        any_word: true
      },
    }

  def self.search_vendors q
    msg_search = search_by_messages(q).except(:select).select(:id)
    vendor_contact_search = Vendor.search_by_contact(q).except(:select).select(:uid)
    vendor_name_search = Vendor.search_by_name(q).except(:select).select(:uid)
    vendor_primary_service_search = Vendor.search_by_primary_service(q).except(:select).select(:uid)
    vendor_services_search = Vendor.search_by_services(q).except(:select).select(:uid)

    where(id: msg_search.pluck(:id))
      .or(where vendor_uid: vendor_contact_search.pluck(:uid) | vendor_name_search.pluck(:uid) |
                            vendor_primary_service_search.pluck(:uid) | vendor_services_search.pluck(:uid))
  end

  def self.search_weddings q
    msg_search = search_by_messages(q).except(:select).select(:id)
    names = q.split('&')

    user_search = User.where('LOWER(firstname) LIKE ?', "%#{names.shift.strip.downcase}%")
    names.each do |name|
      user_search = user_search.or(User.where('LOWER(firstname) LIKE ?', "%#{name.strip.downcase}%"))
    end
    wedding_ids = user_search.pluck(:wedding_id).compact

    where(id: msg_search.pluck(:id))
      .or(where wedding_uid: Wedding.where(id: wedding_ids).pluck(:uid))
  end

  def vendor
    Vendor.find_by_uid vendor_uid
  end

  def wedding
    Wedding.find_by_uid wedding_uid
  end

  def users
    wedding ? wedding.users : []
  end

  def type
    messages.includes(:quote).where(quotes: {status: [Quote::ACCEPTED, Quote::FULFILLED]}).exists? ? 'booking' : 'inquiry'
  end

  def user_msg_count user
    reload.messages.where(user: user).count
  end

  def vendor_msg_count
    reload.messages.where('user_id is ?', nil).count
  end

end
