require 'rails_helper'

describe 'PATCH /my_vendors/:my_vendor_id/quotes/:id/accept' do

  let(:vendor) { auth_user.vendors.create stripe_account_id: 'acct_1AcAmrGbm0vCkBaC', email: 'weplanr@test.com', internal_id: '1.1', primary_service_id: 1}
  let!(:card) { auth_user.wedding.bank_cards.create external_id: '2862d581-fed9-4028-883e-b1c049ded37a' }

  let(:quote) do
    quote_attrs = {
      payment_due: 6.days.from_now,
      delivery_date: 7.weeks.from_now,
      wedding_id: auth_user.wedding.id,
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
    
    _quote = QuoteBuilder.new(vendor, auth_user.wedding, ActionController::Parameters.new(quote_attrs))
    expect(_quote.save).to be_truthy
    _quote
  end

  let(:quote2) do
    quote_attrs = {
      payment_due: 6.days.from_now,
      delivery_date: 5.weeks.from_now,
      wedding_id: auth_user.wedding.id,
      quote_items: [
        {
          name: 'Sounds',
          description: 'The quick brown fox',
          cost: 100,
          total: 200,
        },
        {
          name: 'Props',
          description: 'Jumps over the handsome dog',
          cost: 300,
          total: 300,
        }
      ]
    }

    _quote2 = QuoteBuilder.new(vendor, auth_user.wedding, ActionController::Parameters.new(quote_attrs))
    expect(_quote2.save).to be_truthy
    _quote2
  end


  it 'returns status 200' do
    auth_patch "/api/my_vendors/#{vendor.id}/quotes/#{quote.id}/accept"
    expect(response.status).to eq 200
  end

  it 'updates db' do
    expect {
      auth_patch "/api/my_vendors/#{vendor.id}/quotes/#{quote.id}/accept"
    }.to change{ quote.reload.status }.to Quote::ACCEPTED
  end

  context 'transaction is less $500' do
    it 'does not create a reward transaction' do
      expect {
      auth_patch "/api/my_vendors/#{vendor.id}/quotes/#{quote.id}/accept"
    }.not_to change { RewardTransaction.count }
    end
  end


  context 'transaction is $500 or more' do
    it 'creates a reward transaction' do
      expect {
      auth_patch "/api/my_vendors/#{vendor.id}/quotes/#{quote2.id}/accept"
    }.to change { RewardTransaction.count }.by 1
    end

    it 'does not create a reward transaction - rewards feature is off' do
      reward = Feature.find(3)
      reward.update(status: 0)
      expect {
      auth_patch "/api/my_vendors/#{vendor.id}/quotes/#{quote.id}/accept"
    }.not_to change { RewardTransaction.count }
    end
  end

end
