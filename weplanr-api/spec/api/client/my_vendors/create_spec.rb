require 'rails_helper'

describe 'POST /my_vendors' do

  let(:valid_params) do
    {
      data: {
        attributes: {
          business_name: 'SourcePad',
          social_channels: {
            facebook: 'this'
          }
        }
      }
    }
  end

  it 'returns status 201' do
    auth_post '/api/my_vendors', valid_params
    expect(response.status).to eq 201
  end

  it 'updates db' do
    expect {
      auth_post '/api/my_vendors', valid_params
    }.to change{ Vendor.count }.by 1
  end

end
