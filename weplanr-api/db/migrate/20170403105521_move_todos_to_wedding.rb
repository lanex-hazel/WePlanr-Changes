class MoveTodosToWedding < ActiveRecord::Migration[5.0]
  def up
    add_reference :todos, :wedding, index: true, foreign_key: true

    records = {}
    Todo.all.each do |t|
      records[t] = User.find t.user_id
    end

    remove_reference :todos, :user, index: true

    records.each do |todo, user|
      todo.update wedding: user.wedding
    end
  end

  def down
    add_reference :todos, :user, index: true

    records = {}
    Todo.all.each do |t|
      records[t] = t.user
    end

    remove_reference :todos, :wedding, index: true, foreign_key: true

    records.each do |todo, user|
      todo.update user: user.user
    end
  end
end
