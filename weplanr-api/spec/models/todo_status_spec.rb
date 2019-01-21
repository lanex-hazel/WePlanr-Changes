require 'rails_helper'

describe TodoStatus do

  let!(:user) { auth_user.wedding }

  context '.remove' do
    it 'should update status to remove' do
      user.todo_statuses.create todo_id: 1

      user.todo_statuses.first.remove
      status = user.todo_statuses.first.status

      expect(status).to eq "removed"
    end
  end

  context '.unremove' do
    it 'updates db' do
      user.todo_statuses.create todo_id: 1

      user.todo_statuses.first.unremove
      status = user.todo_statuses

      expect(status.count).to eq 0
    end
  end
end