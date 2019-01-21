require 'rails_helper'

describe 'PATCH /wedding' do

  let(:user) { User.create name: 'SourcePad X WePlanr', email: 'we@sp.com', password: '123' }

  before do
    user.assign_auth_token!
    user.create_wedding location: 'Manila'
    user.save
  end

  let(:valid_params) do
    {
      data: {
        attributes: {
          location: 'Paris'
        }
      }
    }
  end

  it 'returns status 200' do
    auth_patch '/api/wedding', valid_params, user
    expect(response.status).to eq 200
  end

  it 'show correct details' do
    auth_patch '/api/wedding', valid_params, user
    expect(json_response['data']['attributes']['location']).to eq 'Paris'
  end

end
