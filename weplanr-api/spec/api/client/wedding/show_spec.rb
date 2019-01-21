require 'rails_helper'

describe 'GET /wedding' do

  let(:user) { User.create name: 'SourcePad X WePlanr', email: 'we@sp.com', password: '123' }

  before do
    user.assign_auth_token!
    user.create_wedding location: 'Manila'
    user.save
  end

  it 'returns status 200' do
    auth_get '/api/wedding', nil, user
    expect(response.status).to eq 200
  end

  it 'show correct details' do
    auth_get '/api/wedding', nil, user
    expect(json_response['data']['attributes']['location']).to eq 'Manila'

  end

end
