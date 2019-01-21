class TodoNote < ApplicationRecord
  belongs_to :noteable, polymorphic: true
end
