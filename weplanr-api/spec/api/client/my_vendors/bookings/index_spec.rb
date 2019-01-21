require 'rails_helper'

describe 'GET /my_vendors/:id/bookings' do

  let(:vendor) { auth_user.vendors.create business_name: 'SourcePad' }
  let(:other_vendor) { auth_user.vendors.create business_name: 'PadSource' }

  it 'returns status 200' do
    auth_get "/api/my_vendors/#{vendor.id}/bookings"
    expect(response.status).to eq 200
  end

  context 'return bookings' do
    before do
      vendor.bookings.create(schedule: "2017-06-18 13:40:00", client: 'WePlanr', location: 'Sydney', details:'Be on time')
      vendor.bookings.create(schedule: "2017-05-12 18:00:00", client: 'Pixie', location: 'New York', details:'')
      vendor.bookings.create(schedule: "2017-05-31 12:00:00", client: 'SP', location: 'Manila', details:'')
      other_vendor.bookings.create(schedule: Time.now, client: 'SP', location: 'Manila', details:'')
    end
    
    context 'owned by vendor' do
      it 'should return day bookings' do
        auth_get "/api/my_vendors/#{vendor.id}/bookings", {view_type: 'day', date: "2017-06-18"}
        expect(json_response['data'][0]).to be_a Hash
        expect(json_response['data'].count).to eq 1
      end

      it 'should return month bookings' do
        auth_get "/api/my_vendors/#{vendor.id}/bookings", {view_type: 'month', date: "2017-05-01"}
        expect(json_response['data'].count).to eq 2
      end

      it 'should return year bookings' do
        auth_get "/api/my_vendors/#{vendor.id}/bookings", {view_type: 'year', date: "2017"}
        expect(json_response['data'].count).to eq 3
      end
    end

    context 'not owned by vendor' do
      it 'should return empty array' do
        auth_get "/api/my_vendors/#{other_vendor.id}/bookings", {view_type: 'day', date: "2017-05-31"}
        expect(json_response['data'].count).to eq 0
      end
    end
  end

end