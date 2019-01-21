require 'rails_helper'

describe 'GET /verify_invite_token/:invite_token' do

  let!(:vendor) { Vendor.create(email: 'test@sp.com') }
  let!(:invitation) { vendor.create_invitation }

  it 'returns vendor email' do
    get "/api/verify_invite_token/#{invitation.token}"
    expect(json_response['email']).to eq 'test@sp.com'
  end

  context 'invalid' do
    it 'returns 404' do
      get "/api/verify_invite_token/invalid_t0ken"
      expect(response.status).to eq 404
    end
  end

end
