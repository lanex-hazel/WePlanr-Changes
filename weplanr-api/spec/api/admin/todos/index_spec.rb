require 'rails_helper'

describe 'GET /admin/todos' do

  it 'returns status 200' do
    auth_get '/api/admin/todos'
    expect(response.status).to eq 200
  end

end
