require 'rails_helper'

describe 'GET /messages/:vendor_uid' do

  let!(:vendor) { Vendor.create business_name: 'PadSource', email: 'test@email.com' }

  before do
    messenger = Messenger::User.new(auth_user, vendor.uid)
    messenger.send 'foobar'
    messenger.send 'foobar'
  end

  it 'returns status 200' do
    auth_get "/api/messages/#{vendor.uid}"
    expect(response.status).to eq 200
  end

  it 'returns an array' do
    auth_get "/api/messages/#{vendor.uid}"
    expect(json_response['data']).to be_an Array
    expect(json_response['data'].count).to eq 2
  end

end
