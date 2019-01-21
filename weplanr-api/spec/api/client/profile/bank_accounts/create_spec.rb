require 'rails_helper'

describe 'POST /profile/bank_accounts' do

  let(:valid_params) do
    {
      data: {
        attributes: {
          bank_name: 'Bank of Australia',
          account_name: 'Samuel Seller',
          routing_number: '123123',
          account_number: '12341234',
          account_type: 'checking',
          holder_type: 'personal',
          country: 'AUS'   
        }
      }
    }
  end

  xit 'returns status 201' do
    auth_post '/api/profile/bank_accounts', valid_params
    expect(response.status).to eq 201
  end

  xit 'updates db' do
    expect {
      auth_post '/api/profile/bank_accounts', valid_params
    }.to change{ BankAccount.count }.by 1
  end


  context 'invalid params' do
    let(:invalid_params) do
      {
        data: {
          attributes: {
            bank_name: 'Bank of Australia',
            account_name: 'Samuel Seller',
            routing_number: '123123',
            account_number: '12341234',
            account_type: 'checking',
            holder_type: 'personal',
          }
        }
      }
    end


    xit 'return error messages' do
      auth_post '/api/profile/bank_accounts', invalid_params
      expect(json_response['errors']).to be_present
    end

    xit 'not updates db' do
      expect {
        auth_post '/api/profile/bank_accounts', invalid_params
      }.not_to change{ BankAccount.count }
    end
  end

end
