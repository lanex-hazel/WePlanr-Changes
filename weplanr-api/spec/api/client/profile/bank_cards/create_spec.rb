require 'rails_helper'

describe 'POST /profile/bank_cards' do

  let(:valid_params) do
    {
      data: {
        attributes: {
          full_name: 'Bella Buyer',
          number: '4111111111111111',
          expiry_month: '10',
          expiry_year: '2020',
          cvv: '123'
        }
      }
    }
  end

  xit 'returns status 201' do
    auth_post '/api/profile/bank_cards', valid_params
    expect(response.status).to eq 201
  end

  xit 'updates db' do
    expect {
      auth_post '/api/profile/bank_cards', valid_params
    }.to change{ BankCard.count }.by 1
  end


  context 'invalid params' do
    let(:invalid_params) do
      {
        data: {
          attributes: {
            full_name: 'Bella Buyer',
            number: '4111111111111111',
            expiry_month: '10',
            expiry_year: '1994',
            cvv: nil
          }
        }
      }
    end


    xit 'return error messages' do
      auth_post '/api/profile/bank_cards', invalid_params
      expect(json_response['errors']).to be_present
    end

    xit 'not updates db' do
      expect {
        auth_post '/api/profile/bank_cards', invalid_params
      }.not_to change{ BankCard.count }
    end
  end

end
