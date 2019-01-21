module CategorizeConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :category
  end

  def category= str
    self.category_id = Category.find_by_name(str)&.id
  end
end
