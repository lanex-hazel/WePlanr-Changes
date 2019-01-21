require 'rails_helper'

describe 'DELETE /admin/auth_tokens' do

  let(:admin) { Admin.create username: 'weplanr', password: '123' }
  let!(:auth_token) { admin.assign_auth_token! }

  it 'destroys auth_token' do
    expect {
      auth_delete '/api/admin/auth_tokens', nil, admin
    }.to change{ AuthToken.count }.by -1
  end

end
