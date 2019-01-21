require 'rails_helper'

describe 'GET /weddings/profile/:uid' do

  let(:user) { User.create name: 'SourcePad X WePlanr', email: 'we@sp.com', password: '123' }

  before do
    user.create_wedding location: 'Manila'
  end

  it 'returns status 200' do
    auth_get "/api/weddings/profile/#{user.wedding.uid}"
    expect(response.status).to eq 200
  end

  it 'show correct details' do
    auth_get "/api/weddings/profile/#{user.wedding.uid}"
    expect(json_response['data']['attributes']['location']).to eq 'Manila'
  end

end
