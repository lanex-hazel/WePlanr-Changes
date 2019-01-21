class Service < ApplicationRecord
  include CategorizeConcern
  include PgSearch

  pg_search_scope :search,
                  against: [:name],
                  using: {
                    tsearch: {
                      dictionary: 'english',
                      any_word: true
                    },
                    trigram: {
                      threshold: 0.3
                    }
                  }


  def self.order_by_name
    self.order('name ASC')
  end

  def self.primary
    self.where(is_primary: true)
  end

end
