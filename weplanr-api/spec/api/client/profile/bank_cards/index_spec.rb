require 'rails_helper'

describe 'GET /profile/bank_cards' do

  before  do
    BankCard.create wedding: auth_user.wedding
    BankCard.create wedding: auth_user.wedding
  end

  it 'returns status 200' do
    auth_get '/api/profile/bank_cards'
    expect(response.status).to eq 200
  end

  it 'returns correct count' do
    auth_get '/api/profile/bank_cards'
    expect(json_response['data'].count).to eq 2
  end

end
