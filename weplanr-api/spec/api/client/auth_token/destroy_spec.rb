require 'rails_helper'

describe 'DELETE /auth_tokens' do

  let(:user) { User.create email: 'foo@sp.com', password: '123', wedding: Wedding.create }
  let!(:auth_token) { user.assign_auth_token! }

  it 'destroys auth_token' do
    expect {
      auth_delete '/api/auth_tokens', nil, user
    }.to change{ AuthToken.count }.by -1
  end

end
