require 'rails_helper'

describe 'DELETE /my_vendors/:id/bookings/:id' do

  let!(:vendor) { auth_user.vendors.create business_name: 'PadSource' }
  let!(:obj) { vendor.bookings.create schedule: Time.current, client: 'SP', location: 'Manila' }

  it 'updates db' do
    expect {
      auth_delete "/api/my_vendors/#{vendor.id}/bookings/#{obj.id}"
    }.to change{ vendor.bookings.reload.count }.by -1
  end

end
