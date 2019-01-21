require 'rails_helper'

describe Referral do

  context 'user referral' do
    context 'valid' do
      it 'valid attributes' do
        expect(auth_user.wedding.referrals.create(referred_email: 'referral@email.com'))
      end
    end

    context 'invalid' do

      before do
        auth_user.wedding.referrals.create(referred_email: 'referraldup@email.com')
        Vendor.create(business_name: 'Makeup Studio', email: 'makeupstudio@email.com')
      end
      
      it 'duplicate referral' do
        result = auth_user.wedding.referrals.create(referred_email: 'referraldup@email.com')
        expect(result.errors.messages[:base]).to be_an Array
      end

      it 'referral already registered' do
        result = auth_user.wedding.referrals.create(referred_email: 'makeupstudio@email.com')
        expect(result.errors.messages[:base]).to be_an Array
      end

    end
  end

  context 'vendor referral' do

    let(:vendor) { auth_user.vendors.create business_name: 'PadSource', email: 'padsource@email.com' }
    
    context 'valid' do
      it 'valid attributes' do
        expect(vendor.referrals.create(referred_email: 'referral@email.com'))
      end
    end

    context 'invalid' do

      before do
        vendor.referrals.create(referred_email: 'referraldup@email.com')
        Vendor.create(business_name: 'Makeup Studio', email: 'makeupstudio@email.com')
      end
      
      it 'duplicate referral' do
        result = vendor.referrals.create(referred_email: 'referraldup@email.com')
        expect(result.errors.messages[:base]).to be_an Array
      end

      it 'referral already registered' do
        result = vendor.referrals.create(referred_email: 'makeupstudio@email.com')
        expect(result.errors.messages[:base]).to be_an Array
      end

    end
  end

end