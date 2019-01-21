require 'rails_helper'

describe 'GET /profile/bank_accounts' do

  before  do
    BankAccount.create wedding: auth_user.wedding
    BankAccount.create wedding: auth_user.wedding
  end

  it 'returns status 200' do
    auth_get '/api/profile/bank_accounts'
    expect(response.status).to eq 200
  end

  it 'returns correct count' do
    auth_get '/api/profile/bank_accounts'
    expect(json_response['data'].count).to eq 2
  end

end
