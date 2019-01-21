class Admin < ApplicationRecord
  include AuthTokenable
  has_secure_password
end
