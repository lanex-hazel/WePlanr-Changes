require 'rails_helper'

describe 'POST /my_vendors/:vendor_id/messages' do

  let!(:my_vendor) { auth_user.vendors.create business_name: 'PadSource' }
  let!(:bride) { User.create email: 'client@kakaiba.com', password: '123123123' }

  let(:valid_params) do
    wedding = bride.create_wedding

    {
      data: {
        attributes: {
          wedding_uid: wedding.uid,
          message: 'chuwariwariwOOOOH!'
        }
      }
    }
  end


  it 'returns status 201' do
    auth_post "/api/my_vendors/#{my_vendor.uid}/messages", valid_params
    expect(response.status).to eq 201
  end

  it 'saves to db' do
    expect {
      auth_post "/api/my_vendors/#{my_vendor.uid}/messages", valid_params
    }.to change{ Message.count }.by 1
  end

end
