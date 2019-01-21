class PricingAndPackage < ApplicationRecord
  belongs_to :vendor, touch: true
end
