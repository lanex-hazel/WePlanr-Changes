require 'rails_helper'

describe 'GET /my_vendors/:id/statistics' do

  let!(:vendor) { auth_user.vendors.create business_name: 'SourcePad', services: %w(Singer Entertainment), locations: %w(Sydney Manila New\ York) }
  let!(:other_user) { User.create email: 'asd@asd.com', password: '123' }

  it 'returns status 200' do
    auth_get "/api/my_vendors/#{vendor.id}/statistics"
    expect(response.status).to eq 200
  end

  it 'returns stats' do
    vendor.logs.views.create user: other_user
    vendor.logs.views.create user: other_user
    vendor.logs.favorites.create user: other_user#, created_at: Date.today.at_beginning_of_week(:sunday)
    vendor.logs.inquiries.create user: other_user
    vendor.logs.bookings.create user: other_user

    auth_get "/api/my_vendors/#{vendor.id}/statistics"

    expect(json_response['data']['views']).to be_an Array
    expect(json_response['data']['favorites']).to eq 1
    expect(json_response['data']['inquiries']).to eq 1
    expect(json_response['data']['bookings']).to eq 1
  end

end
