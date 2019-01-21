require 'rails_helper'

describe 'DELETE /vendors/:id/unfavorite' do

  let!(:vendor) { Vendor.create business_name: 'SourcePad' }

  before do
    auth_user.favorites.create vendor: vendor
  end

  it 'returns status 200' do
    auth_delete "/api/vendors/#{vendor.id}/unfavorite"
    expect(response.status).to eq 200
  end

  it 'updates db' do
    expect {
      auth_delete "/api/vendors/#{vendor.id}/unfavorite"
    }.to change{ auth_user.favorite_vendors.include? vendor }
  end
end
