require 'rails_helper'

describe 'GET /admin/vendors/:id' do

  let(:vendor) { Vendor.create business_name: 'SourcePad' }

  it 'returns status 200' do
    auth_get "/api/admin/vendors/#{vendor.id}"
    expect(response.status).to eq 200
  end

  it 'returns vendor attributes' do
    auth_get "/api/admin/vendors/#{vendor.id}"
    expect(json_response['data']['attributes']).to include(*%w(business_name))
  end

  it 'returns unavailable dates' do
    vendor.unavailable_dates.create date: Date.today, reason: 'closed'

    auth_get "/api/admin/vendors/#{vendor.id}"

    expect(json_response['data']['attributes']['unavailable_dates'].count).to eq 1
  end

  it 'returns authentication status' do
    vendor.create_invitation
    auth_get "/api/admin/vendors/#{vendor.id}"
    expect(json_response['data']['attributes']['status']).to eq 'Invited'

    vendor.update user: auth_user
    auth_get "/api/admin/vendors/#{vendor.id}"
    expect(json_response['data']['attributes']['status']).to eq 'Registered'
  end

end
