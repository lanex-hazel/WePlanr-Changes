require 'rails_helper'

describe 'GET /admin/vendors' do

  before do
    vendor = Vendor.create business_name: 'SourcePad'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'Welcome'
    Vendor.create business_name: 'Welcoat'
    Vendor.create business_name: 'PadSource'
    Vendor.create business_name: 'PadSource'

    vendor.pricing_and_packages.create name: 'Ceremony', price: 200
    vendor.photos.create image: sample_img, name: 'sample photo'
  end

  it 'returns status 200' do
    auth_get '/api/admin/vendors'
    expect(response.status).to eq 200
  end

  it 'returns all vendors' do
    auth_get '/api/admin/vendors'
    expect(json_response['data'].count).to eq 11
  end


  context 'searching' do

    it 'search with business name' do
      auth_get '/api/admin/vendors?business_name=welc'
      expect(json_response['data'].count).to eq 2
    end

  end

  context 'pagination' do

    it 'returns correctly' do
      auth_get '/api/admin/vendors?page[number]=1'
      expect(json_response['data'].count).to eq 10 # default per page is 10

      auth_get '/api/admin/vendors?page[size]=2&page[number]=6'
      expect(json_response['data'].count).to eq 1
    end

  end

end
