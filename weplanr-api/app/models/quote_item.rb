class QuoteItem < ApplicationRecord
  belongs_to :quote, touch: true

  validates :cost, presence: true
  validates :total, presence: true
  validates :quantity, presence: true

  def total
    return 0 unless cost.present?
    cost * quantity
  end
end
