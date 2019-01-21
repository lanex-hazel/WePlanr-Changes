require 'rails_helper'

describe 'PATCH /profile' do

  let(:valid_params) do
    {
      data: {
        attributes: {
          firstname: 'WePlanr',
          password: 'newpassword',
          metadata_event: {current_state: 'dashboard'},
          wedding_details: {location: 'Maldives'}
        }
      }
    }
  end

  it 'returns status 200' do
    auth_patch '/api/profile', valid_params
    expect(response.status).to eq 200
  end

  it 'changes password' do
    expect {
      auth_patch '/api/profile', valid_params
    }.to change{ auth_user.reload.authenticate('newpassword') }
  end

  it 'show correct details' do
    auth_patch '/api/profile', valid_params
    expect(json_response['data']['attributes']['firstname']).to eq 'WePlanr'
  end

  it 'updates wedding details' do
    auth_patch '/api/profile', valid_params
    expect(json_response['data']['attributes']['wedding_details']['location']).to eq 'Maldives'
  end

  context 'with partner' do

    let(:valid_params_with_partner) do
      {
        data: {
          attributes: {
            firstname: 'WePlanr',
            partner: {
              firstname: 'Bae',
              lastname: 'Olsen',
              role: 'bride',
              email: 'test@weplanr.com',
            }
          }
        }
      }
    end

    it 'returns status 200' do
      auth_patch '/api/profile', valid_params_with_partner
      expect(response.status).to eq 200
    end

    it 'saves partner attributes' do
      expect {
        auth_patch '/api/profile', valid_params_with_partner
      }.to change{ auth_user.partner&.firstname }.to 'Bae'
    end

  end

end
