require 'rails_helper'

describe 'GET /services' do

  it 'returns status 200' do
    get '/api/services'
    expect(response.status).to eq 200
  end

  it 'returns array' do
    get '/api/services'
    expect(json_response['data']).to be_an Array
  end

  it 'should return primary services only' do
    auth_get '/api/services', {primary: true}
    expect(json_response['data']).to_not include(*%w( LGBTQ+ Same\ Sex\ Marriage))
  end

end
