require 'rails_helper'

describe 'GET /messages' do

  let(:vendor_user) { User.create email: 'foo@b4r.com', password: 'awooo' }
  let!(:vendor) { Vendor.create business_name: 'PadSource', user: vendor_user, public_contact_name: 'John Doe', email: 'test@email.com'}

  before do
    messenger = Messenger::User.new(auth_user, vendor.uid)
    messenger.send 'foobar'
    messenger.send 'foobar'
  end

  it 'returns status 200' do
    auth_get '/api/messages'
    expect(response.status).to eq 200
  end

  it 'returns an array' do
    auth_get '/api/messages'
    expect(json_response['data']).to be_an Array
    expect(json_response['data'].count).to eq 1
  end

  context 'filter' do

    it 'returns filters for inquiry' do
      auth_get '/api/messages?filter=inquiry'
      expect(json_response['data'].count).to eq 1
    end

    it 'returns filters for booking' do
      auth_get '/api/messages?filter=booking'
      expect(json_response['data'].count).to eq 0
    end

  end


  context 'searching' do

    it 'searches correctly' do
      # search by content
      auth_get '/api/messages?q=foobar'
      expect(json_response['data'].count).to eq 1

      # search by user
      auth_get "/api/messages?q=#{auth_user.firstname}"
      expect(json_response['data'].count).to eq 1

      # search by vendor
      auth_get '/api/messages?q=PadSource'
      expect(json_response['data'].count).to eq 1

      # no matches
      auth_get '/api/messages?q=qwe'
      expect(json_response['data'].count).to eq 0
    end

  end

end
