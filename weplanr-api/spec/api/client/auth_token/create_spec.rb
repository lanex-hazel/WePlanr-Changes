require 'rails_helper'

describe 'POST /auth_tokens' do

  def send_request email, pw
    post '/api/auth_tokens', params: {
      credentials: {
        email: email,
        password: pw
      }
    }
  end

  let!(:user) do
    _user = User.create email: 'weplanr', password: '123', is_confirmed: true
    _user.create_wedding
    _user.save
    _user
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

  context 'deactive account' do
    before do
      user.wedding.deactivate
    end

    it 'returns 401' do
      send_request 'weplanr', '123'
      expect(response.status).to eq 401
    end
  end

end
