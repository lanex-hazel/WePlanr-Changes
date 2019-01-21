require 'rails_helper'

describe 'POST /register/vendor/:invitation_token' do

  let!(:vendor) { Vendor.create(email: 'test@sp.com') }
  let!(:invitation) { vendor.create_invitation }

  let(:valid_params) do
    {
      data: {
        attributes: {
          invitation_code: invitation.token,
          password: '123',
        }
      }
    }
  end

  it 'returns status 200' do
    post "/api/register/vendor/#{invitation.token}", params: valid_params
    expect(response.status).to eq 200
  end

  it 'saves right attributes in new user' do
    post "/api/register/vendor/#{invitation.token}", params: valid_params
    expect(User.last.email).to eq vendor.email
  end


  context 'invalid invitation token' do

    it 'returns status 404' do
      post '/api/register/vendor/random_token', params: valid_params
      expect(response.status).to eq 404
    end

  end

end
