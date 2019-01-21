require 'rails_helper'

describe 'DELETE /my_vendors/:id/unavailable_dates/:id' do

  let!(:vendor) { auth_user.vendors.create business_name: 'PadSource' }
  let!(:vendor1) { auth_user.vendors.create business_name: 'WePlanr' }
  let!(:obj) { vendor.unavailable_dates.create date: Time.current, reason: 'closed' }

  it 'updates db' do
    expect {
      auth_delete "/api/my_vendors/#{vendor.id}/unavailable_dates/#{obj.id}"
    }.to change{ vendor.unavailable_dates.reload.count }.by -1
  end

  it 'cannot delete other vendor\'s data' do
    auth_delete "/api/my_vendors/#{vendor1.id}/unavailable_dates/#{obj.id}"
    expect(response.status).to eq 404
  end

end
