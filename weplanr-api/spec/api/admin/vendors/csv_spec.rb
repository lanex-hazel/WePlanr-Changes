require 'rails_helper'

describe 'GET /admin/vendors/csv' do

  before do
    Vendor.create business_name: 'SourcePad'
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
  end

  it 'returns status 200' do
    get "/api/admin/vendors/csv?t=#{auth_admin.auth_token}"
    expect(response.status).to eq 200
  end

end
