class OutstandingTodo < ApplicationRecord
  belongs_to :wedding
  belongs_to :todo

  def add_view_count
    update views: (views + 1)
  end

  def reset_views_count
    update views: 0
  end

end
