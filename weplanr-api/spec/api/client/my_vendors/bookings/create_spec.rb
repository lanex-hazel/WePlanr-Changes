require 'rails_helper'

describe 'POST /my_vendors/:id/bookings' do

  let(:vendor) { auth_user.vendors.create business_name: 'PadSource' }

  let(:valid_params) do
    {
      data: {
        attributes: {
          schedule: 1.day.from_now,
          client: 'SP',
          location: 'Manila',
          details: ''
        }
      }
    }
  end

  it 'returns status 201' do
    auth_post "/api/my_vendors/#{vendor.id}/bookings", valid_params
    expect(response.status).to eq 201
  end

  it 'updates db' do
    expect {
      auth_post "/api/my_vendors/#{vendor.id}/bookings", valid_params
    }.to change{ vendor.bookings.reload.count }.by 1
  end

  # it 'cannot book the same time' do
  #   vendor.bookings.create schedule: "2017-05-12 13:40:00", client: 'WePlanr', location: 'Sydney', details: 'Be on time'
  #   valid_params[:data][:attributes][:schedule] = "2017-05-12 13:40:00"
    
  #   auth_post "/api/my_vendors/#{vendor.id}/bookings", valid_params
  #   expect(response.status).to eq 422
  # end

  # it 'creates log for bookings' do
  #   expect {
  #     auth_post "/api/my_vendors/#{vendor.id}/bookings", valid_params
  #   }.to change{ vendor.logs.bookings.count }.by 1
  # end
end
