require 'rails_helper'

describe 'POST /organisr/custom_todos' do

  let(:wedding) { auth_user.wedding }
  let(:valid_params) do
    {
      data: {
        attributes: {
          name: 'Custom todo',
          category: 'Photography',
          timing_min_month: 3,
          timing_max_month: 5
        }
      }
    }
  end


  let(:todo) { wedding.custom_todos.first }

  it 'returns status 201' do
    auth_post '/api/organisr/custom_todos', valid_params
    expect(response.status).to eq 201
  end

  it 'returns correct count' do
    expect {
      auth_post '/api/organisr/custom_todos', valid_params
    }.to change {
      wedding.custom_todos.reload.count
    }.by 1
  end
end
