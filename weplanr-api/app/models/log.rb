class Log < ApplicationRecord
  BOOK     = 'book'
  INQUIRE  = 'inquire'
  VIEW     = 'view'
  FAVORITE = 'favorite'
  ACTIONS  = [ BOOK, INQUIRE, VIEW, FAVORITE ]

  belongs_to :vendor
  belongs_to :user

  scope :bookings,  ->{ where(action: BOOK) }
  scope :inquiries, ->{ where(action: INQUIRE) }
  scope :favorites, ->{ where(action: FAVORITE) }
  scope :views,     ->{ where(action: VIEW) }

end
