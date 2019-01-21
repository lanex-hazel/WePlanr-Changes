require 'rails_helper'

describe 'GET /admin/users' do

  before do
    wedding = Wedding.create

    User.create email: 'foo@sourcepad.com', password: '123', wedding: wedding
    User.create email: 'bar@sourcepad.com', password: '123', wedding: wedding
    User.create email: 'weplanr@sourcepad.com', password: '123', wedding: wedding
  end

  it 'returns status 200' do
    auth_get '/api/admin/users'
    expect(response.status).to eq 200
  end

  it 'returns all users' do
    auth_get '/api/admin/users'
    # TODO: change once admin login is in
    expect(json_response['data'].count).to eq 3
  end

end
