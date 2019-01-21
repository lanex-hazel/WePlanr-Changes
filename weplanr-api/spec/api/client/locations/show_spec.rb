require 'rails_helper'

describe 'GET /locations' do

  it 'returns status 200' do
    get '/api/locations'
    expect(response.status).to eq 200
  end

  it 'returns array' do
    get '/api/locations'
    expect(json_response['data']).to be_an Array
  end

end
