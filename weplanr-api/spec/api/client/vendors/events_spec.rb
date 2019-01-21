require 'rails_helper'

describe 'GET /vendors/:id/events' do

  let!(:vendor) { auth_user.vendors.create business_name: 'SourcePad', services: %w(Singer Entertainment), locations: %w(Sydney Manila New\ York) }
  
  it 'returns status 200' do
    auth_get "/api/vendors/#{vendor.id}/events"
    expect(response.status).to eq 200
  end

  context 'without params' do
    it 'returns calendar events current month' do
      vendor.bookings.create schedule: Date.today, client: 'Thomas Lewers', location: 'Sydney, NSW', details: 'Be on time'
      vendor.unavailable_dates.create date: Date.today - 1, reason: 'fullybooked' 
      vendor.unavailable_dates.create date: Date.today + 1, reason: 'closed'

      auth_get "/api/vendors/#{vendor.id}/events"

      expect(json_response['data']['bookings']).to be_a Array
      expect(json_response['data']['closed']).to be_a Array
      expect(json_response['data']['fullybooked']).to be_a Array
    end
  end

  context 'with params' do
    it 'returns calendar events based on specified date' do
      vendor.bookings.create schedule: Date.today, client: 'Thomas Lewers', location: 'Sydney, NSW', details: 'Be on time'
      vendor.bookings.create schedule: "2017-05-12 13:40:00", client: 'SP', location: 'Melbourne, NSW', details: 'Be on time'
      vendor.unavailable_dates.create date: "2017-05-04", reason: 'fullybooked' 
      vendor.unavailable_dates.create date: "2017-05-09", reason: 'closed'

      auth_get "/api/vendors/#{vendor.id}/events", date: "2017-05-01"

      expect(json_response['data']['bookings']).to be_a Array
      expect(json_response['data']['bookings']).to include "2017-05-01".."2017-05-31"
      expect(json_response['data']['bookings']).to_not include Date.today.at_beginning_of_month..Date.today.at_end_of_month
      expect(json_response['data']['closed']).to be_a Array
      expect(json_response['data']['fullybooked']).to be_a Array

    end
  end
end