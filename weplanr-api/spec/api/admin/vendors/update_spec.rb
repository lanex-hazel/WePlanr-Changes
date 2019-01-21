require 'rails_helper'

describe 'PATCH /admin/vendors/:id' do

  let!(:obj) { Vendor.create business_name: 'SourcePad', social_channels: {facebook: 'asd'} }

  let(:valid_params) do
    {
      data: {
        type: 'vendors',
        id: obj.id,
        attributes: {
          "internal_id": "1.1",
          "uid": "QN7LtwTpc7eoKsXY7r36VQtt",
          "business_name": "Sourcepad Photography 2",
          "registered_street_address": "New York 3",
          "registered_suburb": "New York 3",
          "registered_state": "New York 3",
          "registered_country": "New York 3",
          "registered_post_code": "New York 3",
          "vendor_type": 'custom',
          "suburb": "New York 3",
          "state": "New York 3",
          "firstname": "Public",
          "lastname": "Name",
          "primary_phone": "1111111111",
          "secondary_phone": "2222222222",
          "services": ["Hair", "Makeup", "Photography"],
          "locations": ["NSW", "WA"],
          "social_channels": {"facebook" => nil},
          "website": "https://www.spphotos.com",
          "about": "Description",
          "registered_trading_name": nil,
          "email": "alving@sourcepad.com",
          "contact_name": "Gene Michelle",
          "insurance": false,
          "registered_for_gst": false,
          "invitation_code": nil,
          "unavailable_dates": [{'date' => Time.current, 'reason' => 'fullybooked'}],
          "pricing_and_packages": [{name: "service", price: "123"}]
        }
      }
    }
  end

  it 'returns status 200' do
    auth_patch "/api/admin/vendors/#{obj.id}", valid_params
    expect(response.status).to eq 200
  end

  it 'changes db' do
    auth_patch "/api/admin/vendors/#{obj.id}", valid_params

    obj.reload

    valid_params[:data][:attributes].each do |key, val|
      if key.eql? :unavailable_dates
        #binding.pry
      elsif key.eql? :social_channels
        #binding.pry
      elsif key.eql? :pricing_and_packages
        #binding.pry
      elsif key.eql? :locations
        expect(obj.locations.pluck(:name).flatten.sort).to eq val
      elsif key.eql? :services
        expect(obj.services.pluck(:name).flatten.sort).to eq val
      else
        expect(obj.attributes[key.to_s]).to eq val
      end
    end
  end

end
