require 'rails_helper'

describe 'GET /my_vendors/:id/referrals' do

  let(:vendor) { auth_user.vendors.create business_name: 'PadSource', email: 'padsource@email.com' }
  before do
    vendor.referrals.create referred_email: 'refervendor@email.com'
  end

  it 'returns 200' do
    auth_get "/api/my_vendors/#{vendor.id}/referrals"
    expect(response.status).to eq 200
  end

  context 'returns a referral lists' do
    it 'returns an array' do
      auth_get "/api/my_vendors/#{vendor.id}/referrals"
      expect(json_response['data']).to be_an Array
    end

    it 'does not return pending referrals' do
      auth_get "/api/my_vendors/#{vendor.id}/referrals"
      expect(json_response['data'].count).to eq 0
    end

    it 'returns an only accepted referrals' do
      vendor.referrals.create referred_email: 'refervendor2@email.com', status: 'accepted'
      auth_get "/api/my_vendors/#{vendor.id}/referrals"
      expect(json_response['data'].count).to eq 1
    end
  end
end