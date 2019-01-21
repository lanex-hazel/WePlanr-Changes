require 'rails_helper'

describe 'POST /vendors/:id/favorite' do

  let!(:vendor) { Vendor.create business_name: 'SourcePad' }

  it 'returns status 200' do
    auth_post "/api/vendors/#{vendor.id}/favorite"
    expect(response.status).to eq 200
  end

  it 'updates db' do
    expect {
      auth_post "/api/vendors/#{vendor.id}/favorite"
    }.to change{ auth_user.favorite_vendors.include? vendor }
  end

  context 'on logging' do

    it 'creates one for logged-in user' do
      expect {
        auth_post "/api/vendors/#{vendor.id}/favorite"
      }.to change { vendor.logs.favorites.count }.by 1
    end

    it 'creates one for non-logged-in user' do
      expect {
        auth_post "/api/vendors/#{vendor.id}/favorite"
      }.to change { vendor.logs.favorites.count }.by 1
    end
  end
end
