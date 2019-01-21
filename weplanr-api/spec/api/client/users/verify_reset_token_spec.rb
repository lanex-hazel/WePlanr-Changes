require 'rails_helper'

describe 'GET /users/verify_reset_token' do

  let!(:user) { User.create email: 'reset@test.com', password: '123', reset_password_token: 'token1234'}

  xit 'returns status 204' do
    get "/api/users/verify_reset_token", token: "token1234"
    expect(response.status).to eq 204
  end

  context 'invalid' do
    it 'returns invalid token' do
      get "/api/users/verify_reset_token", token: "tokentest"
      expect(response.status).to eq 401
    end
  end

end
