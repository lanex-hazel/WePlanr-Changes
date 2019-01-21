require 'rails_helper'

describe 'DELETE /admin/photos/:id' do

  let(:vendor1) { Vendor.create business_name: 'SourcePad' }
  let(:vendor2) { Vendor.create business_name: 'SourcePad' }
  let(:vendor3) { Vendor.create business_name: 'SourcePad' }

  before do
    vendor1.photos.create image: sample_img, name: 'sample photo1'
    vendor1.photos.create image: sample_img, name: 'sample photo2'
    vendor1.photos.create image: sample_img, name: 'sample photo3'

    vendor2.photos.create image: sample_img, name: 'sample photo1'
    vendor2.photos.create image: sample_img, name: 'sample photo2'

    vendor3.photos.create image: sample_img, name: 'sample photo'
  end


  it 'returns status 204' do
    auth_delete "/api/admin/photos/#{vendor2.photos.first.id}"
    expect(response.status).to eq 204
  end

  it 'changes db' do
    expect {
      auth_delete "/api/admin/photos/#{vendor2.photos.first.id}"
    }.to change { vendor2.photos.count }.by -1
  end

end
