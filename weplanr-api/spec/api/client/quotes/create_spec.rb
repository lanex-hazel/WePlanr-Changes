require 'rails_helper'

describe 'POST /my_vendors/:my_vendor_id/quotes' do

  let(:vendor) { auth_user.vendors.create business_name: 'vendy', internal_id: '1.1', primary_service_id: 1 }
  let(:other_user) { User.create email: 'random@user.com', password: '123', wedding: Wedding.create }

  let(:valid_params) do
    {
      data: {
        attributes: {
          payment_due: 6.days.from_now,
          wedding_id: other_user.wedding.id,
          quote_items: [
            {
              name: 'Sounds',
              description: 'The quick brown fox',
              cost: 100,
              total: 120,
            },
            {
              name: 'Props',
              description: 'Jumps over the handsome dog',
              cost: 300,
              total: 300,
            }
          ]
        }
      }
    }
  end

  it 'returns status 201' do
    auth_post "/api/my_vendors/#{vendor.slug}/quotes", valid_params
    expect(response.status).to eq 201
  end

  it 'updates db' do
    expect {
      auth_post "/api/my_vendors/#{vendor.slug}/quotes", valid_params
    }.to change{ Quote.count }.by 1
  end

  context 'quote items' do

    it 'updates db' do
      expect {
        auth_post "/api/my_vendors/#{vendor.slug}/quotes", valid_params
      }.to change{ QuoteItem.count }.by 2
    end

  end


  context 'draft' do
    let(:draft_params) do
      _params = valid_params
      _params[:data][:attributes][:status] = Quote::DRAFT
      _params
    end

    it 'creates only 1 draft per wedding' do
      expect {
        expect {
          auth_post "/api/my_vendors/#{vendor.slug}/quotes", draft_params
        }.to change{ Quote.count }.by 1
      }.to change{ QuoteItem.count }.by 2

      expect {
        expect {
          auth_post "/api/my_vendors/#{vendor.slug}/quotes", draft_params
        }.not_to change{ Quote.count }
      }.not_to change{ QuoteItem.count }
    end

  end

  context 'quote for customer referral' do
    let(:referral_vendor) { auth_user.vendors.create business_name: 'ReferralVendor', email: 'referral@mail.com' }

    xit 'creates a discount item for the quote when vendor not yet booked' do
      other_user.wedding.referrals.create referred_email: 'referral@mail.com', status: 'accepted'

      expect {
        auth_post "/api/my_vendors/#{referral_vendor.slug}/quotes", valid_params
      }.to change{ DiscountItem.count }.by 1
    end
  end

end
