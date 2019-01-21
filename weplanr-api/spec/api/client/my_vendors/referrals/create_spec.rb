require 'rails_helper'

describe 'POST /my_vendors/:id/referrals' do

  let(:valid_params) do 
    { data:
      { attributes: 
        {
          referred_email: 'nonweplanrvendor@email.com'
        }
      }
    }
  end

  let(:invalid_params) do 
    { data:
      { attributes: 
        {
          referred_email: 'padsource@email.com'
        }
      }
    }
  end


  let(:vendor) { auth_user.vendors.create business_name: 'PadSource', email: 'padsource@email.com' }
  before do
    vendor.referrals.create referred_email: 'referral@email.com'
  end

  context 'valid' do
    it 'saves to db' do
      expect { 
        auth_post "/api/my_vendors/#{vendor.id}/referrals", valid_params
      }.to change{ Referral.count }.by 1
    end

    xit 'sends an email' do
      expect { 
        auth_post "/api/my_vendors/#{vendor.id}/referrals", valid_params
      }.to change { MandrillMailer.deliveries.count }.by(1)
    end

    it 'returns 201' do 
      auth_post "/api/my_vendors/#{vendor.id}/referrals", valid_params
      expect(response.status).to eq 201
    end
  end

  context 'invalid' do
    it 'returns 422' do
      auth_post "/api/my_vendors/#{vendor.id}/referrals", invalid_params
      expect(response.status).to eq 422
    end

    it 'email already registered' do
      expect { 
        auth_post "/api/my_vendors/#{vendor.id}/referrals", invalid_params
      }.not_to change{ Referral.count }
      expect(json_response['errors']).to be_an Array
    end

    it 'email already referred' do
      expect { 
        auth_post "/api/my_vendors/#{vendor.id}/referrals", {data: {attributes: { referred_email: 'referral@email.com' }}}
      }.not_to change{ Referral.count }
      expect(json_response['errors']).to be_an Array
    end

  end
end
