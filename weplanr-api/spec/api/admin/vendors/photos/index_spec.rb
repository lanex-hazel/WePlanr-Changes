require 'rails_helper'

describe 'GET /admin/vendors/:id/photos' do

  let(:vendor1) { Vendor.create business_name: 'SourcePad' }
  let(:vendor2) { Vendor.create business_name: 'SourcePad' }
  let(:vendor3) { Vendor.create business_name: 'SourcePad' }

  before do
    vendor1.photos.create image: sample_img, name: 'sample photo1'
    vendor1.photos.create image: sample_img, name: 'sample photo2'
    vendor1.photos.create image: sample_img, name: 'sample photo3'

    vendor2.photos.create image: sample_img, name: 'sample photo1'
    vendor2.photos.create image: sample_img, name: 'sample photo2'

    vendor3.photos.create image: sample_img, name: 'sample photo'
  end

  it 'returns status 200' do
    auth_get "/api/admin/vendors/#{vendor3.id}/photos"
    expect(response.status).to eq 200
  end

  it 'returns only respective photos' do
    auth_get "/api/admin/vendors/#{vendor2.id}/photos"
    expect(json_response['data'].count).to eq 2
  end

end
