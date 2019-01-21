require 'rails_helper'

describe 'DELETE /my_vendors/:my_vendor_id/photos/:id' do

  let(:vendor1) { auth_user.vendors.create business_name: 'SourcePad' }
  let(:vendor2) { auth_user.vendors.create business_name: 'SourcePad' }
  let(:vendor3) { auth_user.vendors.create business_name: 'SourcePad' }

  before do
    vendor1.photos.create image: sample_img, name: 'sample photo1'
    vendor1.photos.create image: sample_img, name: 'sample photo2'
    vendor1.photos.create image: sample_img, name: 'sample photo3'

    vendor2.photos.create image: sample_img, name: 'sample photo1'
    vendor2.photos.create image: sample_img, name: 'sample photo2'

    vendor3.photos.create image: sample_img, name: 'sample photo'
  end


  it 'returns status 204' do
    auth_delete "/api/my_vendors/#{vendor2.id}/photos/#{vendor2.photos.first.id}", nil, auth_user
    expect(response.status).to eq 204
  end

  it 'changes db' do
    expect {
      auth_delete "/api/my_vendors/#{vendor2.id}/photos/#{vendor2.photos.first.id}", nil, auth_user
    }.to change { vendor2.photos.count }.by -1
  end

end

