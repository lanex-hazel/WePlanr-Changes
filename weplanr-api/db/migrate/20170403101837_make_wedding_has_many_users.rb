class MakeWeddingHasManyUsers < ActiveRecord::Migration[5.0]
  def up
    add_reference :users, :wedding, index: true, foreign_key: true

    record = {}
    Wedding.all.each do |w|
      record[w] = w.user
    end

    remove_reference :weddings, :user, index: true

    record.each do |wedding, user|
      user.update wedding: Wedding
    end
  end

  def down
    add_reference :weddings, :user, index: true

    record = {}
    User.all.each do |u|
      record[u] = u.wedding
    end

    remove_reference :users, :wedding, index: true, foreign_key: true

    record.each do |user, wedding|
      wedding.update user: user
    end
  end
end
