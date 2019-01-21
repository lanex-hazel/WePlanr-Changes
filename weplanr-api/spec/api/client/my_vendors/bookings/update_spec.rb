require 'rails_helper'

describe 'PATCH /my_vendors/:id/bookings' do

  let(:vendor) { auth_user.vendors.create business_name: 'SourcePad' }
  let(:other_vendor) { auth_user.vendors.create business_name: 'PadSource' }
  let(:booking) {vendor.bookings.create schedule: "2017-05-31 12:00:00", client: 'SP', location: 'Manila', details:'' }
  let(:valid_params) do
    {
      data: {
        attributes: {
          schedule: '2017-05-12 13:40:00',
          details: 'Be on time'
        }
      }
    }
  end

  context 'owned by vendor' do
    it 'returns status 200' do
      auth_patch "/api/my_vendors/#{vendor.id}/bookings/#{booking.id}", valid_params
      expect(response.status).to eq 200
    end

    it 'updates db' do
      expect{
        auth_patch "/api/my_vendors/#{vendor.id}/bookings/#{booking.id}", valid_params
      }.to change{ booking.reload.details }.from('').to 'Be on time'
    end
  end

  context 'not owned by vendor' do
    it 'returns status 404' do
      auth_patch "/api/my_vendors/#{other_vendor.id}/bookings/#{booking.id}", valid_params
      expect(response.status).to eq 404
    end

    it 'does not update db' do
      expect{
        auth_patch "/api/my_vendors/#{other_vendor.id}/bookings/#{booking.id}", valid_params
      }.not_to change{ booking.reload.details }
    end
  end
end