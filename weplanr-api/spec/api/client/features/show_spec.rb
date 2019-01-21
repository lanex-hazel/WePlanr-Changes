require 'rails_helper'

describe 'GET /features/:id' do

  it 'returns status 200' do
    get '/api/features/1'
    expect(response.status).to eq 200
  end

end
