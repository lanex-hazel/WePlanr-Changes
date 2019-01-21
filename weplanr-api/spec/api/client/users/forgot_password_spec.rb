require 'rails_helper'

describe 'PATCH /users/forgot_password' do

  let!(:user) { User.create email: 'reset@test.com', password: '123'}
  let(:valid_params) do
    { email: user.email }
  end

  context 'valid' do
    it 'returns status 204' do
      auth_patch "/api/users/forgot_password", valid_params
      expect(response.status).to eq 204
    end

    it 'updates db' do
      expect {
        auth_patch "/api/users/forgot_password", valid_params
      }.to change{ user.reload.reset_password_token }
    end
  end

  context 'invalid' do
    it 'email does not exist' do
      auth_patch "/api/users/forgot_password", {email: 'unreg@test.com'}
      expect(response.status).to eq 401
    end
  end

end
