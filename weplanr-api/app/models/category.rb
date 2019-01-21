class Category < ApplicationRecord
  has_many :todos
  has_many :custom_todos
  has_many :services
end
