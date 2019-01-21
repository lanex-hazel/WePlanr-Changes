class Location < ApplicationRecord
  has_and_belongs_to_many :vendors
  belongs_to :vendor

  scope :defaults, ->{ where(vendor_id: nil).order_by_name }

  def self.order_by_name
    self.order('name ASC')
  end
end
