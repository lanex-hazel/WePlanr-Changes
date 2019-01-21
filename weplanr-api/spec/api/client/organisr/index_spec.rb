require 'rails_helper'

describe 'GET /organisr' do

  before do
    wedding = auth_user.wedding
    wedding.update budget: 1000 # create brokendown budgets
    wedding.custom_todos.create name: 'custom'

    auth_user.save # save wedding_id
  end

  it 'returns status 200' do
    auth_get '/api/organisr'
    expect(response.status).to eq 200
  end

  it 'returns correct count' do
    todos_count = auth_user.wedding.default_todos.count + 1

    auth_get '/api/organisr'
    expect(json_response['data'].count).to eq todos_count
  end

  context 'notes' do
    it 'returns notes for default' do
      auth_user.wedding.todo_notes.create(noteable: Todo.first, content: 'foo')
      auth_get '/api/organisr'
      expect( json_response['data'].map{|i| i['attributes']['notes']} ).to include('foo')
    end

    it 'returns notes for custom' do
      auth_user.wedding.todo_notes.create(noteable: auth_user.wedding.custom_todos.first, content: 'custom')
      auth_get '/api/organisr'
      expect( json_response['data'].map{|i| i['attributes']['notes']} ).to include('custom')
    end
  end
end