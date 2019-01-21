require 'rails_helper'

describe 'PATCH /admin/vendors/:id/profile_photo' do

  let!(:vendor) { Vendor.create(business_name: 'PadSource', primary_service: Category.first) }

  before do
    vendor.photos.create image: sample_img
  end


  it 'adds to db' do
    expect {
      auth_patch "/api/admin/vendors/#{vendor.id}/profile_photo", {
        photo_id: Photo.last.id
      }
    }.to change { Vendor.last.profile_photo }
  end

end
