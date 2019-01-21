require 'rails_helper'

describe 'GET /admin/users/csv' do

  before do
    User.create email: 'sample@asd123.com', password: '123123123'
    User.create email: 'sample@asdqwe.com', password: 'qweqweqwe'
  end

  it 'returns status 200' do
    get "/api/admin/users/csv?t=#{auth_admin.auth_token}"
    expect(response.status).to eq 200
  end

end
