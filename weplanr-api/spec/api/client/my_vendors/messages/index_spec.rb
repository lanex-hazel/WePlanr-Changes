require 'rails_helper'

describe 'GET /my_vendors/:vendor_id/messages' do

  let!(:my_vendor) { auth_user.vendors.create business_name: 'PadSource' }
  let!(:bride) { User.create email: 'client@kakaiba.com', password: '123123123' }

  before do
    messenger = Messenger::Vendor.new(my_vendor)
    messenger.send auth_user.uid, 'foobar'
    messenger.send auth_user.uid, 'foobar'
  end

  it 'returns status 200' do
    auth_get "/api/my_vendors/#{my_vendor.uid}/messages"
    expect(response.status).to eq 200
  end

  it 'returns an array' do
    auth_get "/api/my_vendors/#{my_vendor.uid}/messages"
    expect(json_response['data']).to be_an Array
    expect(json_response['data'].count).to eq 1
  end

  context 'filter' do

    it 'returns filters for inquiry' do
      auth_get "/api/my_vendors/#{my_vendor.uid}/messages?filter=inquiry"
      expect(json_response['data'].count).to eq 1
    end

    it 'returns filters for booking' do
      auth_get "/api/my_vendors/#{my_vendor.uid}/messages?filter=booking"
      expect(json_response['data'].count).to eq 0
    end

  end

end
