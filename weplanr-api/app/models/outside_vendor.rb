class OutsideVendor < ApplicationRecord

  belongs_to :wedding
  belongs_to :todo
  has_many :todo_statuses
  has_many :todos, through: :todo_statuses
  has_many :custom_todos

  validates :business_name, presence: true
  validates :address_summary, presence: true
  validates :total_fee, presence: true

  after_create :link_to_todo
  def link_to_todo
    if custom_todo_id
      wedding.custom_todos.find(custom_todo_id).update(status: 'booked', outside_vendor: self)
    elsif budget_id
      budget = wedding.budgets.find(budget_id)
      budget.todo_status.update(status: 'booked', outside_vendor: self)
    end
  end
  attr_accessor :budget_id, :custom_todo_id

  def link_to_defaulttodo todo, wedding
    todo_statuses.create(todo: todo, wedding: wedding, status: 'booked')
  end

  def link_to_customtodo todo, vendor
    todo.update(outside_vendor: vendor, status: 'booked')
  end

  def default_todo_item todo
    todo_statuses.find_by_todo_id(todo).todo
  end
end
