require 'rails_helper'

describe 'GET /todos' do

  before do
    wedding = auth_user.wedding
    wedding.update budget: 1000 # create brokendown budgets
    wedding.custom_todos.create name: 'custom'

    auth_user.save # save wedding_id
  end

  it 'returns status 200' do
    auth_get '/api/todos/dashboard'
    expect(response.status).to eq 200
  end

  it 'returns max 6' do
    auth_get '/api/todos/dashboard'
    expect(json_response['data'].count).to eq 6
  end

  it 'returns default TODOs order' do
    auth_get '/api/todos/dashboard'
    expect( json_response['data'].map{|i| i['attributes']['name']} ).to eq Todo.order(timing_min_month: :desc, position: :asc).limit(6).pluck(:name)
  end

  it 'returns 1st 6 TODOs as long as all are not checked' do
    # update
    Todo.order(timing_min_month: :desc, position: :asc).limit(5).each{|todo| auth_user.wedding.todo_statuses.create(todo: todo, status: TodoStatus::BOOKED) }

    auth_get '/api/todos/dashboard'
    expect( json_response['data'].map{|i| i['attributes']['name']} ).to eq Todo.order(timing_min_month: :desc, position: :asc).limit(6).pluck(:name)
  end

  it 'returns next 6 TODOs if 1st 6 are checked' do
    # update
    Todo.order(timing_min_month: :desc, position: :asc).limit(6).each{|todo| auth_user.wedding.todo_statuses.create(todo: todo, status: TodoStatus::BOOKED) }

    auth_get '/api/todos/dashboard'
    expect( json_response['data'].map{|i| i['attributes']['name']} ).to eq Todo.order(timing_min_month: :desc, position: :asc).limit(6).offset(6).pluck(:name)
  end
end