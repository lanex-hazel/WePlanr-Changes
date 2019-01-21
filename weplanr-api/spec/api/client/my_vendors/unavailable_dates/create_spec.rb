require 'rails_helper'

describe 'POST /my_vendors/:id/unavailable_dates' do

  let(:vendor) { auth_user.vendors.create business_name: 'PadSource' }

  let(:valid_params) do
    {
      data: {
        attributes: {
          date: 1.day.from_now,
          reason: 'fullybooked'
        }
      }
    }
  end

  let(:invalid_params) do
    {
      data: {
        attributes: {
          date: nil,
          reason: nil
        }
      }
    }
  end

  it 'returns status 201' do
    auth_post "/api/my_vendors/#{vendor.id}/unavailable_dates", valid_params
    expect(response.status).to eq 201
  end

  it 'updates db' do
    expect {
      auth_post "/api/my_vendors/#{vendor.id}/unavailable_dates", valid_params
    }.to change{ vendor.unavailable_dates.reload.count }.by 1
  end

  it 'does not allow two dates for one vendor' do
    vendor.unavailable_dates.create date: 1.day.from_now, reason: 'closed'

    auth_post "/api/my_vendors/#{vendor.id}/unavailable_dates", valid_params
    expect(response.status).to eq 422
  end

  it 'does not create when date and reason is nil' do
    auth_post "/api/my_vendors/#{vendor.id}/unavailable_dates", invalid_params
    expect(response.status).to eq 422
  end

  it 'does not create when reason is not valid' do
    invalid_params[:data][:attributes][:reason] = 'vacation'

    auth_post "/api/my_vendors/#{vendor.id}/unavailable_dates", invalid_params
    expect(response.status).to eq 422
  end

end
