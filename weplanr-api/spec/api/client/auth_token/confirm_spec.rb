require 'rails_helper'

describe 'PATCH /auth_tokens/confirm' do

  let!(:user) { User.create email: 'confirm@test.com', password: '123',wedding: Wedding.create}
  let!(:other_user) { User.create email: 'confirm2@test.com', password: '123', is_confirmed: true }
  let(:valid_params) do
    { confirmation_token: user.confirmation_token }
  end
  let(:invalid_params) do
    { confirmation_token: 'token123'}
  end

  context 'valid' do
    it 'returns status 200' do
      auth_patch "/api/auth_tokens/confirm", valid_params
      expect(response.status).to eq 200
    end

    it 'updates db' do
      expect {
        expect {
          auth_patch "/api/auth_tokens/confirm", valid_params
        }.to change{ user.reload.is_confirmed }.to eq true
      }.to change{ user.reload.confirmation_token }.to eq nil
    end
  end

  context 'invalid' do
    it 'not a valid token' do
      auth_patch "/api/auth_tokens/confirm", invalid_params
      expect(response.status).to eq 401
    end

    it 'user is already confirmed' do
      auth_patch "/api/auth_tokens/confirm",   { confirmation_token: other_user.confirmation_token }
      expect(response.status).to eq 401
    end
  end

end