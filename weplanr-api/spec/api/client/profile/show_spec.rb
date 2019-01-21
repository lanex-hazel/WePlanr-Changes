require 'rails_helper'

describe 'GET /profile' do

  let(:user) { User.create name: 'SourcePad X WePlanr', email: 'we@sp.com', password: '123', wedding: Wedding.create, metadata_event: {current_state: 'dashboard'} }

  before do
    user.assign_auth_token!
  end

  it 'returns status 200' do
    auth_get '/api/profile', nil, user
    expect(response.status).to eq 200
  end

  it 'show correct details' do
    auth_get '/api/profile', nil, user
    expect(json_response['data']['attributes']['firstname']).to eq user.firstname
  end


  context 'not logged in' do

    it 'returns error 401' do
      get '/api/profile'
      expect(response.status).to eq 401
      expect(json_response['error']).to be_present
    end

  end

end
