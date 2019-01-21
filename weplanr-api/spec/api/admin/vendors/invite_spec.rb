require 'rails_helper'

describe 'POST /admin/vendors/:id/invite' do

  let!(:vendor) { Vendor.create business_name: 'SaucePad', email: 'test@sp.com' }

  it 'changes db' do
    expect {
      auth_post "/api/admin/vendors/#{vendor.id}/invite"
    }.to change { vendor.reload.invitation }
  end

  it 'sends an email' do
    expect {
      auth_post "/api/admin/vendors/#{vendor.id}/invite"
    }.to change { ActionMailer::Base.deliveries.count }.by 1
  end

end
