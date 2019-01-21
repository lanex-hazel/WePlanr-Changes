require 'rails_helper'

describe 'GET /referrals' do

  before do
    auth_user.wedding.referrals.create referred_email: 'refervendor@email.com', status: 'accepted'
  end

  it 'returns 200' do
    auth_get '/api/referrals'
    expect(response.status).to eq 200
  end

  it 'returns an array' do
    auth_get "/api/referrals"
    expect(json_response['data']).to be_an Array
    expect(json_response['data'].count).to eq 1
  end
end
