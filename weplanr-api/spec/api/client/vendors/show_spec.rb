require 'rails_helper'

describe 'GET /vendors/:id' do
  let(:vendor) { Vendor.create business_name: 'SourcePad' }

  before do
    vendor.photos.create image: sample_img, name: 'sample photo1'
  end

  it 'returns status 200' do
    auth_get "/api/vendors/#{vendor.id}"
    expect(response.status).to eq 200
  end

  it 'show vendor details' do
    auth_get "/api/vendors/#{vendor.id}"
    expect(json_response['data']['attributes']).to include 'business_name'
  end

  it 'show pricing_and_packages' do
    vendor.pricing_and_packages.create name: 'Flowers', price: 4.99
    vendor.pricing_and_packages.create name: 'Gown', price: 499

    auth_get "/api/vendors/#{vendor.id}"
    expect(json_response['data']['attributes']['pricing_and_packages'].count).to eq 2
  end

  it 'allows slugs intead of id' do
    auth_get "/api/vendors/#{vendor.slug}"
    expect(json_response['data']['attributes']['business_name']).to eq 'SourcePad'
  end

  context 'on view' do

    it 'creates one for logged-in user' do
      expect {
        auth_get "/api/vendors/#{vendor.id}"
      }.to change { vendor.logs.views.count }.by 1
    end

    it 'creates one for non-logged-in user' do
      expect {
        get "/api/vendors/#{vendor.id}"
      }.to change { vendor.logs.views.count }.by 1
    end
  end
end
