require 'rails_helper'

describe 'POST /my_vendors/:my_vendor_id/photos' do

  let(:vendor) { auth_user.vendors.create(business_name: 'PadSource') }

  context 'single photo' do

    it 'adds to db' do
      expect {
        auth_post "/api/my_vendors/#{vendor.id}/photos", vendor: {
          photo: sample_img
        }
      }.to change { Photo.count }.by 1
    end

  end

  context 'multiple photos' do

    it 'adds to db' do

      expect {
        auth_post "/api/my_vendors/#{vendor.id}/photos", vendor: {
          photos: [sample_img, sample_img]
        }
      }.to change { Photo.count }.by 2
    end

  end

end
