require 'rails_helper'

describe 'GET /profile/favorites' do

  before do
    sourcepad = Vendor.create business_name: 'SourcePad'
    weplanr = Vendor.create business_name: 'WePlanr'

    auth_user.favorites.create!(vendor: sourcepad)
    auth_user.favorites.create!(vendor: weplanr)
  end

  it 'returns status 200' do
    auth_get '/api/profile/favorites'
    expect(response.status).to eq 200
  end

  it 'show correct details' do
    auth_get '/api/profile/favorites'
    expect(json_response['data'].count).to eq 2
  end

end
