require 'rails_helper'

describe 'GET /admin/users/:id' do

  let(:user) { User.create email: 'sample@email.com', password: '123', wedding: Wedding.create }

  it 'returns status 200' do
    auth_get "/api/admin/users/#{user.id}"
    expect(response.status).to eq 200
  end

  it 'returns right user attributes' do
    auth_get "/api/admin/users/#{user.id}"
    expect(json_response['data']['attributes']).to include(*%w(email))
  end

end
