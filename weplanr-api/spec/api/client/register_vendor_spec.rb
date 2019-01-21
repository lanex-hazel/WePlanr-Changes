require 'rails_helper'

describe 'POST /register/vendor' do

  let(:valid_params) do
    {
      data: {
        attributes: {
          primary_service_id: '1',
          services: ['Coordination'],
          email: 'user@email.com',
          password: '123123',
          business_name: 'Tenenen',
          # card
          full_name: 'Bella Buyer',
          number: '4111111111111111',
          expiry_month: '10',
          expiry_year: '2020',
          cvv: '123',
        }
      }
    }
  end

  let(:referral_params) do
    {
      data: {
        attributes: {
          primary_service_id: 1,
          services: ['Coordination'],
          email: 'refervendor@email.com',
          password: '123123',
          business_name: 'Vendor Referral',
          # card
          full_name: 'Vendor Buyer',
          number: '4111111111111111',
          expiry_month: '10',
          expiry_year: '2020',
          cvv: '123',
          promo_code: auth_user.wedding.referral_code.code
        }
      }
    }
  end

  it 'returns status 201' do
    post '/api/register/vendor', params: valid_params
    expect(response.status).to eq 201
  end

  it 'saves right attributes in new vendor' do
    post '/api/register/vendor', params: valid_params
    expect(Vendor.last.business_name).to eq 'Tenenen'
  end

  context 'on error' do

    it 'returns error' do
      User.create email: 'user@email.com', password: 'qweasdzxc'

      expect {
        post '/api/register/vendor', params: valid_params
      }.not_to change{ Vendor.count }
    end

  end

  context 'handle referral' do

    context 'user referral' do

      let(:user_referral) {auth_user.wedding.referrals.create referred_email: 'refervendor@email.com'}

      it 'updates referred vendor\'s status to accept' do
        expect {
          post '/api/register/vendor', params: referral_params
        }.to change{ user_referral.reload.status }.from('pending').to 'accepted'
      end

      it 'accepts a referred vendor using code' do
        referral_params[:data][:attributes][:email] = 'refervendor2@email.com'
        expect {
          post '/api/register/vendor', params: referral_params
        }.to change{ Referral.count }.to eq 1
      end

      context 'referral feature is off' do

        before do
          Feature.find(1).update(status: 0)
        end

        it 'returns 422 - feature is not available' do
          post '/api/register/vendor', params: referral_params
          expect(response.status).to eq 422
        end
      end
    end

    context 'vendor referral' do
      let(:vendor) {auth_user.vendors.create business_name: 'PadSource'}
      let(:vendor_referral) {vendor.referrals.create referred_email: 'makeupstudio@email.com'}

      before do
        referral_params[:data][:attributes][:email] = 'makeupstudio@email.com'
        referral_params[:data][:attributes][:promo_code] = vendor.referral_code.code
      end

      it 'updates referred vendor\'s status to accept' do
        expect {
          post '/api/register/vendor', params: referral_params
        }.to change{ vendor_referral.reload.status }.from('pending').to 'accepted'
      end

      it 'accepts a referred vendor using code' do
        referral_params[:data][:attributes][:email] = 'styling@email.com'
        expect {
          post '/api/register/vendor', params: referral_params
        }.to change{ Referral.count }.to eq 1
      end

      context 'referral feature is off' do

        before do
          Feature.find(2).update(status: 0)
        end

        it 'returns 422 - feature is not available' do
          post '/api/register/vendor', params: referral_params
          expect(response.status).to eq 422
        end
      end
    end

    it 'returns 422 - invalid referral code' do
      referral_params[:data][:attributes][:promo_code] = 'refer101'
      post '/api/register/vendor', params: referral_params
      expect(response.status).to eq 422
    end

  end
end
