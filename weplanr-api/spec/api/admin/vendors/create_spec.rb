require 'rails_helper'

describe 'POST /admin/vendors' do

  let(:valid_params) do
    {
      data: {
        type: 'vendors',
        attributes: {
          'business_name': 'PadSource'
        }
      }
    }
  end

  it 'returns status 201' do
    auth_post '/api/admin/vendors', valid_params
    expect(response.status).to eq 201
  end

  it 'changes db' do
    expect {
      auth_post '/api/admin/vendors', valid_params
    }.to change { Vendor.count }.by 1
  end

end
