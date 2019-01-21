require 'rails_helper'

describe Wedding do

  context 'on budget update' do

    # NOTE: might change depends on the answer on questions on specs
    xit 'creates budget based on # of todos' do
      obj = Wedding.create

      expect{
        obj.update budget: 30_000
      }.to change{ obj.budgets.count }.by Todo.count

      expect{
        Wedding.create budget: 30_000
      }.to change{ Budget.count }.by Todo.count
    end

  end

  context 'referral code' do
    it 'assigns a referral code' do
      expect {
        obj = Wedding.create
        expect(obj.referral_code).to be_present
      }.to change { ReferralCode.count }.by 1
    end
  end

  context 'update outstanding todos' do
    it 'updates on first pending item' do
      obj = Wedding.create
      obj.create_outstanding_todo todo: auth_user.pending_todos.order(timing_max_month: :desc, timing_min_month: :desc).first
      obj.todo_statuses.create(todo_id: 1, status: 'booked')
      expect {
        obj.update_outstanding_todo
      }.to change{ obj.outstanding_todo.reload.todo_id }.from(1).to 2
    end
  end

end
