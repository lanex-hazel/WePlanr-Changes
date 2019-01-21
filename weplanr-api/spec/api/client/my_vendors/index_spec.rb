require 'rails_helper'

describe 'GET /my_vendors' do

  let!(:sourcepad) { auth_user.vendors.create business_name: 'SourcePad', services: %w(Singer Entertainment), locations: %w(Sydney Manila New\ York) }
  let!(:weplanr) { auth_user.vendors.create business_name: 'WePlanr', services: %w(Makeup Hairstyling), locations: %w(Sydney Melbourne) }
  let!(:jabee) { Vendor.create business_name: 'Jollibee', services: %w(Singer Mascot), locations: %w(Sydney) }

  it 'returns status 200' do
    auth_get '/api/my_vendors'
    expect(response.status).to eq 200
  end

  it 'returns all vendors' do
    auth_get '/api/my_vendors'
    expect(json_response['data'].count).to eq 2
  end

end
