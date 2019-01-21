require 'rails_helper'

describe 'PATCH /organisr/:type/:id' do

  let(:wedding) { auth_user.wedding }
  let(:valid_params) do
    {
      data: {
        attributes: {
          planned: 888,
        }
      }
    }
  end


  before do
    wedding.update budget: 1000 # create brokendown budgets
    wedding.custom_todos.create name: 'custom'

    auth_user.save # save wedding_id
  end

  context 'type=todos' do
    let(:budget) { wedding.budgets.first }

    it 'returns status 200' do
      auth_patch "/api/organisr/todos/#{budget.id}", valid_params
      expect(response.status).to eq 200
    end

    it 'returns correct count' do
      expect {
        auth_patch "/api/organisr/todos/#{budget.id}", valid_params
      }.to change {
        budget.reload.planned
      }.to 888
    end
  end


  context 'type=custom_todos' do
    let(:todo) { wedding.custom_todos.first }

    it 'returns status 200' do
      auth_patch "/api/organisr/custom_todos/#{todo.id}", valid_params
      expect(response.status).to eq 200
    end

    it 'returns correct count' do
      expect {
        auth_patch "/api/organisr/custom_todos/#{todo.id}", valid_params
      }.to change {
        todo.reload.planned
      }.to 888
    end
  end
end
