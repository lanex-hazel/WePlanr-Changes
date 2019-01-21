require 'rails_helper'

describe 'GET /my_vendors/:id/unavailable_dates' do

  let!(:vendor) { auth_user.vendors.create business_name: 'SourcePad', services: %w(Singer Entertainment), locations: %w(Sydney Manila New\ York) }
  
  it 'returns status 200' do
    auth_get "/api/my_vendors/#{vendor.id}/unavailable_dates"
    expect(response.status).to eq 200
  end

  it 'returns unavailable_dates' do
    vendor.unavailable_dates.create date: Date.today - 1, reason: 'fullybooked' 
    vendor.unavailable_dates.create date: Date.today + 1, reason: 'closed'

    auth_get "/api/my_vendors/#{vendor.id}/unavailable_dates"

    expect(json_response['data']['closed']).to be_a Hash
    expect(json_response['data']['fullybooked']).to be_a Hash
  end
end