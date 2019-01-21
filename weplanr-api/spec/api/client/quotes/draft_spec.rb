require 'rails_helper'

describe 'GET /my_vendors/:my_vendor_id/quotes/draft' do

  let(:vendor) { auth_user.vendors.create internal_id: '1.1', primary_service_id: 1}

  let!(:quote) do
    quote_attrs = {
      payment_due: 6.days.from_now,
      wedding_id: auth_user.wedding.id,
      status: 'draft',
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


  it 'returns draft quote' do
    auth_get "/api/my_vendors/#{vendor.id}/quotes/draft?wedding_id=#{auth_user.wedding.id}"
    expect(json_response['data']['attributes']['status']).to eq 'draft'
  end

end
