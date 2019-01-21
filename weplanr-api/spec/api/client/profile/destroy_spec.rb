require 'rails_helper'

describe 'DELETE /profile' do

  before do
    # create user before requests
    auth_user
  end

  it 'returns status 204' do
    auth_delete '/api/profile'
    expect(response.status).to eq 204
  end

  it 'destroy auth tokens' do
    expect {
      auth_delete '/api/profile'
    }.to change{ AuthToken.count }.from(1).to 0
  end

end
