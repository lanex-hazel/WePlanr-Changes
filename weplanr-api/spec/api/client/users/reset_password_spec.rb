require 'rails_helper'

describe 'PATCH /users/reset_password' do

  let!(:user) { User.create email: 'reset@test.com', password: '123', reset_password_token: 'token1234'}
  let(:valid_params) do { 
      email: user.email,
      password: user.password,
      token: 'token1234',
      new_password: 'password'
    }
  end

  let(:invalid_params) do { 
      email: user.email,
      password: 'test123',
      token: 'token1234',
      new_password: 'password'
    }
  end

  let(:invalid_params2) do { 
      email: 'unreg@test.com',
      password: 'test123',
      token: 'token1234',
      new_password: 'password'
    }
  end

  context 'valid' do
    it 'returns status 204' do
      auth_patch "/api/users/reset_password", valid_params
      expect(response.status).to eq 204
    end

    it 'updates db' do
      expect {
        auth_patch "/api/users/reset_password", valid_params
      }.to change {user.reload.reset_password_token}.to eq nil
    end
  end

  context 'invalid' do
    it 'authentication failed' do
      auth_patch "/api/users/reset_password", invalid_params
      expect(response.status).to eq 401
    end
    it 'users does not exist' do
      auth_patch "/api/users/reset_password", invalid_params2
      expect(response.status).to eq 401
    end
  end

end
