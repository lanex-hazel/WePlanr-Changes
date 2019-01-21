require 'rails_helper'

describe 'PATCH /admin/referrals/:id' do

  let(:obj) { Referral.create referred_email: 'foo@bar.com', gift_card_sent: true }

  xit 'returns status 200' do
    auth_patch "/api/admin/referrals/#{obj.id}", data: {attributes: {gift_card_sent: false}}
    expect(response.status).to eq 200
  end

end
