require 'rails_helper'

describe 'POST /messages' do

  let!(:vendor) { Vendor.create business_name: 'PadSource', email: 'test@email.com'}

  let(:valid_params) do
    {
      data: {
        attributes: {
          vendor_uid: vendor.uid,
          content: 'chuwariwariwap'
        }
      }
    }
  end


  it 'returns status 201' do
    auth_post '/api/messages', valid_params
    expect(response.status).to eq 201
  end

  it 'saves to db' do
    expect {
      auth_post '/api/messages', valid_params
    }.to change{ Message.count }.by 1
  end

  context 'on logging' do

    it 'adds on db' do
      expect {
        auth_post '/api/messages', valid_params
        auth_post '/api/messages', valid_params
      }.to change { vendor.logs.inquiries.count }.by 1
    end

  end
end
