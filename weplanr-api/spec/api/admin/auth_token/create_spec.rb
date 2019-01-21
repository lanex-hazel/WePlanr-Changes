require 'rails_helper'

describe 'POST /admin/auth_tokens' do

  def send_request uname, pw
    post '/api/admin/auth_tokens', params: {
      credentials: {
        username: uname,
        password: pw
      }
    }
  end

  before do
    Admin.create username: 'weplanr', password: '123'
  end


  context 'valid' do
    it 'creates auth_token' do
      expect {
        send_request 'weplanr', '123'
      }.to change{ AuthToken.count }.by 1
    end
  end

  context 'invalid' do
    it 'not create auth_token' do
      expect {
        send_request 'weplanr', 'wrong'
      }.not_to change{ AuthToken.count }
    end
  end

end
